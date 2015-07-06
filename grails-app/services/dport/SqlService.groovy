package dport

import grails.transaction.Transactional

import groovy.sql.Sql
import org.codehaus.groovy.grails.web.json.JSONArray;

@Transactional
class SqlService {
    // injected
    def sessionFactory, dataSource

    def serviceMethod() {

    }

    // sql selection strings
    public static final String SEARCH_VARIANT_VAR_ID_SQL_STRING =
    """
    select var_id as returnStr from variant where (var_id rlike ':snippet') limit :limit
    """

    /**
     * insert a set of variants give a collection
     *
     * @param variants
     * @param numberOfVariants
     * @return
     */
    Integer insertArrayOfVariants(JSONArray variants, Integer numberOfVariants) {
        // create local variables
        Sql sql = new Sql( sessionFactory.currentSession.connection() )
        String varId, dbSnpId, chromosome, varIdFirstCharacters, dbSnpIdFirstCharacters
        Long position
        Long minPosition = -1, maxPosition = -1

        String insertSqlString = """
            insert into variant (var_id, var_id_first_characters, db_snp_id, db_snp_id_first_characters, position, chromosome, version) values(?, ?, ?, ?, ?, ?, 0)
        """

        String deleteSqlString = """
            delete from variant where chromosome = ? and position <= ? and position >= ?
        """

        // find max and min positions to delete first
        // hack for now
        for ( int  i = 0 ; i < variants?.size() ; i++ ) {
            def variant = variants[i];
            position = variant["POS"].findAll { it }[0]
            chromosome = variant["CHROM"].findAll { it }[0]

            if ((maxPosition < 1) || (position > maxPosition)) {
                maxPosition = position
            }
            if ((minPosition < 1) || (position < minPosition)) {
                minPosition = position
            }
        }

        // delete for all in between positions
        sql.execute(deleteSqlString, [chromosome, maxPosition, minPosition])

        // loop and insert variants
        for ( int  i = 0 ; i < variants?.size() ; i++ ) {
            def variant = variants[i];

            varId = variant["VAR_ID"].findAll { it }[0]
            dbSnpId = (variant["DBSNP_ID"].findAll { it }[0] ? variant["DBSNP_ID"].findAll { it }[0] : "")
            position = (variant["POS"].findAll { it }[0] ? variant["POS"].findAll { it }[0] : "")
            chromosome = variant["CHROM"].findAll { it }[0]
            varIdFirstCharacters = (varId?.length() > 7 ? varId[0..6] : varId)
            dbSnpIdFirstCharacters = (dbSnpId?.length() > 7 ? dbSnpId[0..6] : dbSnpId)

            if (varId.length() > 760) {
                // skip for now, identifier too long for db table
                log.info("skipping variant: " + varId + " because the identifier is too long");
                continue;
            }

            def sqlParams = [varId, varIdFirstCharacters, dbSnpId, dbSnpIdFirstCharacters, position, chromosome]
//            log.info("sql params: " + sqlParams)

            // getting H2 exception for long varId of size 260, so wrap; hopefully won't interfere with mysql
            try {
                sql.execute(insertSqlString, sqlParams)

            } catch (org.h2.jdbc.JdbcSQLException exception) {
                log.error("got sql exception: " + exception.getMessage())
            }
        }

        // log
        log.info("added array of variants for chromosome: " + chromosome + " of size: " + numberOfVariants + " with max position: " + maxPosition)

        // return
        return maxPosition
    }

    /**
     * insert a set of variants give a collection
     *
     * @param variants
     * @param numberOfVariants
     * @param chromosome
     * @return
     */
    Integer insertArrayOfVariantsForChromosome(def variants, Integer numberOfVariants, String chromosome) {
        // create local variables
        Sql sql = new Sql( sessionFactory.currentSession.connection() )
        Integer returnPosition = 0;
        String varId, dbSnpId, varIdFirstCharacters, dbSnpIdFirstCharacters
        Long position

        String insertSqlString = """
            insert into variant (var_id, var_id_first_characters, db_snp_id, db_snp_id_first_characters, position, chromosome, version) values(?, ?, ?, ?, ?, ?, 0)
        """

        String deleteSqlString = """
            delete from variant where chromosome = ?
        """

        // delete for all in chromosome
        sql.execute(deleteSqlString, [chromosome])

        // loop and insert variants
        for ( int  i = 0 ; i < numberOfVariants ; i++ ) {
            def variant = variants[i];

            varId = variant["VAR_ID"].findAll { it }[0]
            dbSnpId = (variant["DBSNP_ID"].findAll { it }[0] ? variant["DBSNP_ID"].findAll { it }[0] : "")
            position = (variant["POS"].findAll { it }[0] ? variant["POS"].findAll { it }[0] : "")
            chromosome = variant["CHROM"].findAll { it }[0]
            returnPosition = position
            varIdFirstCharacters = (varId?.length() > 7 ? varId[0..6] : varId)
            dbSnpIdFirstCharacters = (dbSnpId?.length() > 7 ? dbSnpId[0..6] : dbSnpId)

            if (varId.length() > 760) {
                // skip for now, identifier too long for db table
                log.info("skipping variant: " + varId + " because the identifier is too long");
                continue;
            }

            def sqlParams = [varId, varIdFirstCharacters, dbSnpId, dbSnpIdFirstCharacters, position, chromosome]
//            log.info("sql params: " + sqlParams)

            // getting H2 exception for long varId of size 260, so wrap; hopefully won't interfere with mysql
            try {
                sql.execute(insertSqlString, sqlParams)

            } catch (org.h2.jdbc.JdbcSQLException exception) {
                log.error("got sql exception: " + exception.getMessage())
            }
        }

        // log
        log.info("added array of variants for chromosome: " + chromosome + " of size: " + numberOfVariants + " with return position: " + returnPosition)

        // return
        return returnPosition
    }


    /**
     * search variant table for string in either name or snp id
     *
     * @param snippet                       string to search for
     * @param limitNumber                   number of elements to return
     * @return                              a list of string
     */
    List<String> getVariantListFromSnippetUsingRLike(String snippet, Integer limitNumber) {
        Sql sql = new Sql( sessionFactory.currentSession.connection() )
        List<String> stringList = new ArrayList<String>();

        String sqlString = """
        select var_id as returnStr from variant where (var_id rlike '^:snippet')
        union
        select db_snp_id as returnStr from variant where (db_snp_id rlike '^:snippet')
        limit :limit
        """

        stringList = this.getStringListFromSnippetUsingSqlString(sqlString, snippet, limitNumber);

        log.info("found: " + stringList.size() + " variants for rlike search of term: '" + snippet + "'")
        return stringList
    }

    /**
     * search variant table for string in either name or snp id
     *
     * @param snippet                       string to search for
     * @param limitNumber                   number of elements to return
     * @return                              a list of string
     */
    List<String> getVariantListFromSnippet(String snippet, Integer limitNumber) {
        Sql sql = new Sql( sessionFactory.currentSession.connection() )
        List<String> stringList = new ArrayList<String>();


        String sqlString = """
        select var_id as returnStr from variant where (var_id like ':snippet%')
        union
        select db_snp_id as returnStr from variant where (db_snp_id like ':snippet%')
        limit :limit
        """

        String sqlStringFirstCharacters = """
        select var_id as returnStr from variant where (var_id_first_characters like ':snippet%')
        union
        select db_snp_id as returnStr from variant where (db_snp_id_first_characters like ':snippet%')
        limit :limit
        """

        // execute and build list
        sql.eachRow(sqlString, [snippet: snippet, limit: limitNumber]) {
            stringList << it.returnStr
        }

        log.info("found: " + stringList.size() + " variants for search of term: '" + snippet + "'")
        return stringList
    }

    /**
     * generic method to run sql string query and return list of strings
     *
     * @param sqlString
     * @param snippet
     * @param limitNumber
     * @return
     */
    List<String> getStringListFromSnippetUsingSqlString(String sqlString, String snippet, Integer limitNumber) {
        Sql sql = new Sql( sessionFactory.currentSession.connection() )
        List<String> stringList = new ArrayList<String>();

        def params = [snippet: "${snippet}", limit: "${limitNumber}"]
        log.info("params are: " + params)

        // execute sql and build list
        sql.eachRow("select var_id as returnStr from variant where (var_id rlike '?1.snippet') limit ?2.limit", params) { row ->
            stringList << row.returnStr
        }

        log.info("found: " + stringList.size() + " for snippet: " + snippet + " and limit: " + limitNumber + " and SQL: " + sqlString)

        return stringList
    }

    List<String> getVariantStringListFromSnippetUsingRLikeQuery(String snippet, Integer limitNumber) {
        Sql sql = new Sql( sessionFactory.currentSession.connection() )
        List<String> stringList = new ArrayList<String>();

        String sqlString

        if (isVarIdString(snippet)) {
            if (snippet?.length() > 5) {
                String smallSnippet = snippet[0..4]

                sqlString =
                        """
            select var_id as returnStr from variant where var_id_first_characters = '${smallSnippet}' and var_id rlike '^${snippet}' limit ${limitNumber}
            """

            } else {
                sqlString =
                        """
            select var_id as returnStr from variant where var_id_first_characters rlike '^${snippet}' limit ${limitNumber}
            """
            }

            // execute sql and build list
            sql.eachRow(sqlString) { row ->
                stringList << row.returnStr
            }

            log.info("found variant: " + stringList.size() + " for snippet: " + snippet + " and limit: " + limitNumber + " and SQL: " + sqlString)

        } else {
            log.info("skipped variant sql query for search string: " + snippet)
        }

        return stringList
    }

    List<String> getDbSnpIdStringListFromSnippetUsingRLikeQuery(String snippet, Integer limitNumber) {
        Sql sql = new Sql( sessionFactory.currentSession.connection() )
        List<String> stringList = new ArrayList<String>();

        String sqlString

        if (this.isDbSnpIdString(snippet)) {
            // pick what query based on size of input
            if (snippet?.length() > 4) {
                String smallSnippet = snippet[0..3]

                sqlString =
                        """
                select db_snp_id as returnStr from variant where db_snp_id_first_characters = '${smallSnippet}' and db_snp_id rlike '^${snippet}' limit ${limitNumber}
                """

            } else {
                sqlString =
                        """
                select db_snp_id as returnStr from variant where db_snp_id_first_characters rlike '^${snippet}' limit ${limitNumber}
                """
            }

            // execute sql and build list
            sql.eachRow(sqlString) { row ->
                stringList << row.returnStr
            }

            log.info("found dbSnp size: " + stringList.size() + " for snippet: " + snippet + " and limit: " + limitNumber + " and SQL: " + sqlString)
        } else {
            log.info("skip sbSnpId search for snippet: " + snippet)
        }


        return stringList
    }

    /**
     * test to see if string given could be a dbSnpId search string
     *
     * @param snippet
     * @return
     */
    public boolean isDbSnpIdString(String snippet) {
        // assumption that all dbSnpId string start with 'rs'
        def match = /^[rR][sS].*/
        return ((snippet?.length() > 1) && (snippet =~ match))
    }

    /**
     * test to see if string given is start of variant
     */
    public boolean isVarIdString(String snippet) {
        // assumption that all varId strings start with number and then underscore
        def match = /^[1-9XYMxym].*/
        return (snippet =~ match)
    }

}

