
Feature: As a Ontology User, I want to check table structure tests

Background:
   Given I set up the database connections for "Staging" - "STABLE" environment for "chem" schema tables count
   And I set up the database connections for "Ingest" - "CCDEV" environment for "chem" schema tables count
   And I set up the database connections for "Exposure" - "CCDEV" environment for "chem" schema tables count

@testCountCI
Scenario: Check the list of tables exists in a specific CI domain area
  When I execute following query for "Staging" Schema for table counting:
  """
  Select owner,table_name from ALL_TAB_COLUMNS where owner='CI_PUBLIC_STAGING' AND
  lower(table_name) IN ('jp_action_tree_ad','jp_patent_drug_compound','jp_patent_drug_compound_hlink','jp_patent_drug_compound_name','jp_pf_annotation_display','jp_pf_company')
  order by table_name
  """
  When I execute following query for "Ingest" Schema for table counting:
  """
  SELECT table_schema, table_name as TableName from information_schema.tables where table_schema='cips_ingest'
  AND table_name IN ('jp_action_tree_ad','jp_patent_drug_compound','jp_patent_drug_compound_hlink','jp_patent_drug_compound_name','jp_pf_annotation_display','jp_pf_company')
  order by table_name
  """
  When I execute following query for "Exposure" Schema for table counting:
  """
  SELECT table_schema, table_name as TableName from information_schema.tables where table_schema='ci_public'
  AND table_name IN ('jp_action_tree_ad','jp_patent_drug_compound','jp_patent_drug_compound_hlink','jp_patent_drug_compound_name','jp_pf_annotation_display','jp_pf_company')
  order by table_name
  """
  Then I should get the counts of "Staging","Ingest" against "Exposure" in html format

#@ccdev
#Scenario: Check the list of tables exists between Ingest vs Exposure in CCDEV
# Given I set up the database connections for "Ingest" on "CCDEV" environment
# And I set up the database connections for "Exposure" on "CCDEV" environment
#
#@ccprod
#Scenario: Check the list of tables exists between Ingest vs Exposure in CCPROD
# Given I set up the database connections for "Ingest" on "CCPROD" environment
# And I set up the database connections for "Exposure" on "CCPROD" environment
#
#@ccdev @oracle
#Scenario: Check the list of tables exists between Ingest vs Staging in CCDEV
# Given I set up the database connections for "Ingest" on "CCDEV" environment
# And I set up the database connections for "Staging" on "STABLE" environment
#
#@ccdev @oracle
#Scenario: Check the list of tables exists between Ingest vs PROD in CCDEV
# Given I set up the database connections for "Ingest" on "CCDEV" environment
# And I set up the database connections for "Staging" on "PROD" environment

