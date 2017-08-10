package org.broadinstitute.mpg.locuszoom

/**
 * Bean class to encapsulate phenotype information for the LZ dropdown selection and LZ display withing the plot
 *
 */
public class PhenotypeBean {
    String key
    String displayName
    String name
    String description
    String propertyName
    String dataSet
    String dataSetReadable
    String dataType
    List listOfMeanings
    Boolean defaultSelected
    Boolean suitableForDefaultDisplay
}
