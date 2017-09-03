
Feature: As a Ontology User, I want to check table structure tests in STABLE_STAGING and CCDEV_CCDB
         so that I can use them confidently
 Background:
   Given I set up the database connections for "STAGING" on "STABLE" environment
   And I set up the database connections for "INGEST" on "CCDEV" environment
 
 @tableExistCheck
 Scenario: Check the list of Ontology 6tables exists in Stable Staging VS CCDEV
   When I execute following query for "source" Schema:
   """
   SELECT lower(table_name) as TableName from all_tables
   where owner='INDEX_TREE_EXPORT' and lower(table_name)
   IN ('ddf_dictionary','ddf_dictionary_exclude','ephmra','ephmra_action','ephmra_indication','ephmra_tree') order by table_name
   """
   When I execute following query for "target" Schema:
   """
   SELECT table_name as TableName from information_schema.tables
   where table_schema='ite_ingest' and table_name
   IN ('ddf_dictionary','ddf_dictionary_exclude','ephmra','ephmra_action','ephmra_indication','ephmra_tree') order by table_name
   """
   Then I should get the difference from "Source" to "Target" in "Ontology_Staging_CCDEV_TablesExists" csv file
   And I should get the difference from "Target" to "Source" in "Ontology_CCDEV_Staging_TablesExists" csv file

 @colCountCheck
 Scenario: Check the list of Ontology Column Counts in Stable Staging VS CCDEV
   Given I set up the database connections for "Staging" on "STABLE" environment
   And I set up the database connections for "Ingest" on "CCDEV" environment
   When I execute following query for "source" Schema:
   """
   Select lower(table_name) as TableName, Count(*) ColumnCount from ALL_TAB_COLUMNS where owner='INDEX_TREE_EXPORT' and
   lower(table_name) IN ('ddf_dictionary','ddf_dictionary_exclude','ephmra','ephmra_action','ephmra_indication','ephmra_tree')
   GROUP BY table_name ORDER BY table_name
   """
   When I execute following query for "target" Schema:
   """
   Select table_name as TableName,Count(*) ColumnCount from information_schema.columns where table_schema='ite_ingest' and
   table_name IN ('ddf_dictionary','ddf_dictionary_exclude','ephmra','ephmra_action','ephmra_indication','ephmra_tree')
   GROUP BY table_name order by table_name
   """
   Then I should get the difference from "Source" to "Target" in "Ontology_Staging_CCDEV_ColCount" csv file
   And I should get the difference from "Target" to "Source" in "Ontology_CCDEV_Staging_ColCount" csv file


 @colNamesCheck
 Scenario: Check the list of Ontology tables for Column Names Check in Stable Staging VS CCDEV
   Given I set up the database connections for "Staging" on "STABLE" environment
   And I set up the database connections for "Ingest" on "CCDEV" environment
   When I execute following query for "source" Schema:
   """
   Select lower(table_name) as TableName, lower(column_name) as ColumnName from ALL_TAB_COLUMNS where owner='INDEX_TREE_EXPORT' and
   lower(table_name) IN ('ddf_dictionary','ddf_dictionary_exclude','ephmra','ephmra_action','ephmra_indication','ephmra_tree','indication_tree_ad')
   ORDER BY TableName,ColumnName
   """
   When I execute following query for "target" Schema:
   """
   Select table_name as TableName, column_name as ColumnName  from information_schema.columns where table_schema='ite_ingest' and
   table_name IN ('ddf_dictionary','ddf_dictionary_exclude','ephmra','ephmra_action','ephmra_indication','ephmra_tree','indication_tree_ad')
   ORDER BY TableName,ColumnName
   """
   Then I should get the difference from "Source" to "Target" in "Ontology_Staging_CCDEV_ColCount" csv file
   And I should get the difference from "Target" to "Source" in "Ontology_CCDEV_Staging_ColCount" csv file
