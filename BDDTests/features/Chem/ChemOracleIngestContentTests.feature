
Feature: As a Chem User, I want to check content of some of the tables in the Chem schema so I can use it confindentaly

Background:
  Given I set up the database connection for "Staging" on "STABLE" environment for "Chem" schema
  And I set up the database connection for "Exposure" on "CCDEV" environment for "Chem" schema

@chemTableContentOra
Scenario: Check the Chem Tables Count are Identical between Ingest Exposure
  When I execute following query for "source" Schema:
  """
  Select * from CHEM_PROC.ch_ddr_name where ROWNUM <=10 AND lower(DDF_RN) like 'ace%' ORDER BY 1
  """
  When I execute following query for "target" Schema:
  """
  Select * from chem_proc_ingest.ch_ddr_name where lower(DDF_RN) like 'ace%' ORDER BY 1 limit 10

  """
#  Then I should get the difference from "Source" minus "Target" in "Chem_Ingest_Exposure_TableContent" csv file
  Then I should get the difference from "Target" minus "Source" in "Chem_Exposure_Ingest_TableContent" csv file

