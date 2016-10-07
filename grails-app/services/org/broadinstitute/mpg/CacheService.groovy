package org.broadinstitute.mpg

import grails.plugin.cache.CacheEvict

/**
 * Service class to flush the cached queries
 *
 * Created by mduby on 10/6/16.
 */
class CacheService {
    // DIGP-400: added evict annotation in other service class since a Spring bug keeps it from working in the same class as the Cacheable annotation

    @CacheEvict(value = "variantsInfoCache", allEntries = true)
    public void evictVariantsInfoCache() {
        log.info("clearing variants info cache");
        // nothing to do; annotation does it all
        // NOTE: for the 'evict' annotation to work, it has to be called from outside the class (no inline calls)
    }

    @CacheEvict(value = "variantCountCache", allEntries = true)
    public void evictVariantsCountCache() {
        log.info("clearing variants count cache");
        // nothing to do; annotation does it all
        // NOTE: for the 'evict' annotation to work, it has to be called from outside the class (no inline calls)
    }

    @CacheEvict(value = "burdenCache", allEntries = true)
    public void evictBurdenCache() {
        log.info("clearing burden cache");
        // nothing to do; annotation does it all
        // NOTE: for the 'evict' annotation to work, it has to be called from outside the class (no inline calls)
    }

    @CacheEvict(value = "burdenTraitCache", allEntries = true)
    public void evictBurdenTraitCache() {
        log.info("clearing burden cache");
        // nothing to do; annotation does it all
        // NOTE: for the 'evict' annotation to work, it has to be called from outside the class (no inline calls)
    }

    @CacheEvict(value = "sampleCache", allEntries = true)
    public void evictSampleCache() {
        log.info("clearing samples cache");
        // nothing to do; annotation does it all
        // NOTE: for the 'evict' annotation to work, it has to be called from outside the class (no inline calls)
    }

    @CacheEvict(value = "variantsCache", allEntries = true)
    public void evictVariantsCache() {
        log.info("clearing variants cache");
        // nothing to do; annotation does it all
        // NOTE: for the 'evict' annotation to work, it has to be called from outside the class (no inline calls)
    }

    @CacheEvict(value = "hailCache", allEntries = true)
    public void evictHailCache() {
        log.info("clearing Hail cache");
        // nothing to do; annotation does it all
        // NOTE: for the 'evict' annotation to work, it has to be called from outside the class (no inline calls)
    }


}
