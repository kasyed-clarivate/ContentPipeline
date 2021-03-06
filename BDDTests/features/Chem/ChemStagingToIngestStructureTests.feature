@chem
Feature: As a Chem User, I want to check structure of tables and its content in the Chem schema from Staging stable to CCDEV_Ingest
so I can use it confindentaly

Background:
  Given I set up the database connection for "Staging" on "STABLE" environment for "Chem" schema
  And I set up the database connection for "Ingest" on "CCDEV" environment for "Chem" schema

@chemTableCountOra @TableCount
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
  Then I should get the difference from "Source" minus "Target" in "TableCount" csv file
  And I should get the difference from "Target" minus "Source" in "TableCount" csv file

@chemTableNamesOra @TableNames
Scenario: Check the Chem Tables Names List are Identical between Ingest Exposure
  When I execute following query for "source" Schema:
  """
  Select DISTINCT table_name as TableName from ALL_TAB_COLUMNS where owner='CHEM_PROC' AND lower(table_name) not like '%ch_structure%'
  AND lower(table_name) not like '%temp%' AND lower(table_name) not like '%view%' AND lower(table_name) not like '%_pending%'
  ORDER BY table_name
  """
  When I execute following query for "target" Schema:
  """
  SELECT table_name as TableName from information_schema.tables where table_schema='chem_proc_ingest'
  AND table_name NOT LIKE '%log%' """
  Then I should get the difference from "Source" minus "Target" in "TableNames" csv file
  And I should get the difference from "Target" minus "Source" in "TableNames" csv file
