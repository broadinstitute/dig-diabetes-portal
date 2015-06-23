package dport

import grails.transaction.Transactional

import groovy.sql.Sql;

@Transactional
class SqlService {
    // injected
    def sessionFactory, dataSource

    def serviceMethod() {

    }

    Integer insertArrayOfVariants(def variants, Integer numberOfVariants) {
        // create local variables
        Sql sql = new Sql( sessionFactory.currentSession.connection() )
        Integer returnPosition = 0;
        String varId, dbSnpId, chromosome
        Long position
        Long minPosition = -1, maxPosition = -1

        String insertSqlString = """
            insert into variant (var_id, db_snp_id, position, chromosome, version) values(?, ?, ?, ?, 0)
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

            if (varId.length() > 250) {
                // skip for now, identifier too long for db table
                log.info("skipping variant: " + varId + " because the identifier is too long");
                continue;
            }

            def sqlParams = [varId, dbSnpId, position, chromosome]
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

}
