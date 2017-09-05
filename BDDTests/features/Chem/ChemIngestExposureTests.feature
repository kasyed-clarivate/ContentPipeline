@chem @chemIngestExposure
Feature: As a Chem User, I want to check structure of tables and its content in the Chem schema so I can use it confindentaly

Background:
  Given I set up the database connection for "Ingest" on "CCDEV" environment for "Chem" schema
  And I set up the database connection for "Exposure" on "CCDEV" environment for "Chem" schema

@chemTableCount @TableCount
Scenario: Check the Chem Tables Count are Identical between Ingest Exposure
  When I execute following query for "source" Schema:
  """
  SELECT Count(table_name) as TableCount FROM information_schema.tables where table_schema='chem_proc_ingest'
  and table_name NOT LIKE '%log%'
  """
  When I execute following query for "target" Schema:
  """
  SELECT Count(table_name) as TableCount FROM information_schema.tables where table_schema='chem'
  AND table_name NOT LIKE '%view%'
  """
  Then I should get the difference from "Source" minus "Target" in "TableCounts" csv file
  And I should get the difference from "Target" minus "Source" in "TableCounts" csv file

@chemTableNames @TableNames
Scenario: Check the Chem Tables Names List are Identical between Ingest Exposure
  When I execute following query for "source" Schema:
  """
  SELECT table_name as TableName from information_schema.tables where table_schema='chem_proc_ingest'
  AND table_name NOT LIKE '%log%'
  """
  When I execute following query for "target" Schema:
  """
  SELECT table_name as TableName FROM information_schema.tables where table_schema='chem'
  AND table_name NOT LIKE '%view%'
  """
  Then I should get the difference from "Source" minus "Target" in "TableNames" csv file
  And I should get the difference from "Target" minus "Source" in "TableNames" csv file

@chemColumnsCount @ColumnsCount
Scenario: Check the Chem Column Counts are Identical between Ingest Exposure
  When I execute following query for "source" Schema:
  """
  Select table_name,Count(*) ColumnCount from information_schema.columns where table_schema='chem_proc_ingest' AND table_name NOT LIKE '%log%'
  GROUP BY table_name Order by table_name
  """
  When I execute following query for "target" Schema:
  """
  Select table_name,Count(*) ColumnCount  from information_schema.columns where table_schema='chem' AND table_name NOT LIKE '%view%'
  and column_name NOT LIKE 'acn' GROUP BY table_name Order By table_name
  """
  Then I should get the difference from "Source" minus "Target" in "ColCount" csv file
  And I should get the difference from "Target" minus "Source" in "ColCount" csv file


@chemColumnsNames @ColumnsNames
Scenario: Check the List of Column Names in all tables are Identical between Ingest Exposure
  When I execute following query for "source" Schema:
  """
  Select table_name TableName, column_name as ColumnName from information_schema.columns where table_schema='chem_proc_ingest' AND table_name NOT LIKE '%log%'
  Order By TableName,ColumnName
  """
  When I execute following query for "target" Schema:
  """
  Select table_name TableName, column_name as ColumnName from information_schema.columns where table_schema='chem' AND table_name NOT LIKE '%view%'
  and column_name NOT LIKE 'acn' Order By TableName,ColumnName
  """
  Then I should get the difference from "Source" minus "Target" in "ColNames" csv file
  And I should get the difference from "Target" minus "Source" in "ColNames" csv file
