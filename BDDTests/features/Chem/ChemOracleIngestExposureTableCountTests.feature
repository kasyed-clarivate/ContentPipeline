
Feature: As a Chem User, I want to check count of different tables in Chem schema across three different so I can use it confindentaly

Background:
  Given I set up the database connection for "Staging" on "STABLE" environment for "Chem" schema
  And I set up the database connection for "Exposure" on "CCDEV" environment for "Chem" schema

@chemTablesCount
Scenario: Check the Chem Tables Count are Identical between Ingest Exposure
  When I execute following query for "source" Schema:
  """
  Select count(table_name) as TableCount from all_tab_columns where owner='CHEM_PROC' AND lower(table_name) not like '%ch_structure%'
  AND lower(table_name) not like '%temp%' AND lower(table_name) not like '%view%' AND lower(table_name) not like '%_pending%'
  """
  When I execute following query for "target" Schema:
  """
  SELECT Count(table_name) as TableCount FROM information_schema.tables where table_schema='chem_proc_ingest'
  and table_name NOT LIKE '%log%'
  """
  Then I should get the difference from "Source" minus "Target" in "Chem_Ingest_Exposure_TableCount" csv file
  And I should get the difference from "Target" minus "Source" in "Chem_Exposure_Ingest_TableCount" csv file
