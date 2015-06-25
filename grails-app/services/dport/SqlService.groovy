package dport

import grails.transaction.Transactional

import groovy.sql.Sql;

@Transactional
class SqlService {
    // injected
    def sessionFactory, dataSource

    def serviceMethod() {

    }

    /**
     * insert a set of variants give a collection
     *
     * @param variants
     * @param numberOfVariants
     * @return
     */
    Integer insertArrayOfVariants(def variants, Integer numberOfVariants) {
        // create local variables
        Sql sql = new Sql( sessionFactory.currentSession.connection() )
        Integer returnPosition = 0;
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
        for ( int  i = 0 ; i < numberOfVariants ; i++ ) {
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

}
