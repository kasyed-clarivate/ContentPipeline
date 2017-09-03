from behave import given, when, then
from BDDCommon.CommonFuncs import CommonFunctions;
# import BDDCommon.CommonFuncs.CommonFunctions;
import pdb;


@given(u'I set up the database connection for "{schema}" on "{dbEnv}" environment for "{domArea1}" schema')
def I_setup_the_database_connections_for_Oracle(context, schema, dbEnv,domArea1):
    context.domArea1 = domArea1;
    print("In Start of Setup <<--===COUNNECTION COUNT.... :", context.conCount)
    if (context.conCount == 0):
        context.source_con = CommonFunctions.connect_db(schema, dbEnv)
    else:
        context.target_con = CommonFunctions.connect_db(schema, dbEnv)
    context.conCount += 1
    print("COUNNECTION COUNT.... :", context.conCount)

# @given(u'I set up the database connection for "{schema1}" on "{dbEnv1}" environment for "{domaArea1}" schema')
# def I_setup_the_database_connections_for_Oracle_for_Schema(context, schema1, dbEnv1, domaArea1):
#     context.domArea1=domaArea1;
#     I_setup_the_database_connections_for_Oracle(context, schema1, dbEnv1)
    #context.execute_steps(u'''I set up the database connections for "{schema1}" on "{dbEnv1}" environment'''.format(schema1,dbEnv1))
##----------------------------------------------------------------------------------------------------------------------------
@when(u'I execute following query for "{executeSchema}" Schema')
def I_execute_following_query_for_Schema(context, executeSchema):
    isTargetDiffDone = 0
    if (executeSchema.lower() == 'source'.lower()):
        context.diffSourceToTarget = []
        source_cursor = context.source_con.cursor()
        source_cursor.execute(context.text)
        context.listSource = source_cursor.fetchall()
        # print("+++++---------Context.listSource-----+++ :",context.listSource)
        colNames1 = [cols[0] for cols in source_cursor.description]
        print("ColNames1 :", colNames1)
        context.diffSourceToTarget.append(colNames1)
        print("context.diffSourceToTarget ===> ", context.diffSourceToTarget)
    elif (executeSchema.lower() == 'target'.lower()):
        context.diffTargetToSource = []
        target_cursor = context.target_con.cursor()
        target_cursor.execute(context.text)
        context.listTarget = target_cursor.fetchall()
        # print("+++++---------Context.listTarget-----+++ :", context.listTarget)
        colNames2 = [cols[0] for cols in target_cursor.description]
        print("ColNames2 :", colNames2)
        context.diffTargetToSource.append(colNames2)
        print("context.diffTargetToSource ===> ", context.diffTargetToSource)
        isTargetDiffDone = 1
    else:
        print("In Oracle Rows..!!")
    ##--------Column Equality Check----------
    if (isTargetDiffDone == 1):
        context.diffSourceToTarget[0] = [x.lower() for x in context.diffSourceToTarget[0]]
        context.diffTargetToSource[0] = [x.lower() for x in context.diffTargetToSource[0]]
        assert context.diffSourceToTarget == context.diffTargetToSource, "----->>>----Source and Target Columns are not Equal...!----->>>----"
    print("Query :", context.text)
    print("Schema Name : {}".format(executeSchema))
    print("<<---------------End of I execute following query...------------------------->>")


####------------------------------------------------------------------------------------------------------------------------------
@then(u'I should get the difference from "{diffSchema1}" minus "{diffSchema2}" in "{diffSchema1ToSchema2FileName}" csv file')
def I_should_get_the_difference_from_schema1_to_schema2_in_csv_file(context, diffSchema1, diffSchema2,
                                                                    diffSchema1ToSchema2FileName):
    print("In Last Step ---- context.diffSourceToTarget ===> ", context.diffSourceToTarget)
    print("In Last Step ---- context.diffTargetToSource ===> ", context.diffTargetToSource)

    print("diffSchema1 ------------->>>>>>>> {}".format(diffSchema1))
    print("diffSchema2 ------------->>>>>>>> {}".format(diffSchema2))
    if (diffSchema1.lower() == "source"):
        print("context.listSource :", context.listSource)
        isPresent = 0
        for row_ing in context.listSource:
            for row_exp in context.listTarget:
                if (row_ing != row_exp):
                    isPresent = 0
                else:
                    isPresent = 1
                    break
            if (isPresent == 0):
                context.diffSourceToTarget.append(row_ing)
        print("~~~~~~~Length of DiffSourceToTarget--~~~~~~----> diffSourceToTarget : ", len(context.diffSourceToTarget))
        CommonFunctions.write_csv(context, context.diffSourceToTarget, diffSchema1ToSchema2FileName)
        assert len(context.diffSourceToTarget) <= 1, "There are differences between source to Target..!!"
    elif ((diffSchema1.lower()) == "target"):
        print("context.listTarget :", context.listTarget)
        isPresent = 0
        for row_exp in context.listTarget:
            for row_ing in context.listSource:
                if (row_exp != row_ing):
                    isPresent = 0
                else:
                    isPresent = 1
                    break
            if (isPresent == 0):
                context.diffTargetToSource.append(row_exp)
        print("~~~~~~~Length of diffTargetToSource--~~~~~~----> diffTargetToSource : ", context.diffTargetToSource)
        CommonFunctions.write_csv(context, context.diffTargetToSource, diffSchema1ToSchema2FileName)
        assert len(context.diffTargetToSource) <= 1, "There are differences between target to source..!!"
    else:
        print("Oracle Schema...Not implemented Yet..!")

##----------------------------------------------------------------------
#####-------------------------------------------------------------------
@given(u'I set up the database connections for "{schema}" - "{dbEnv}" environment for "{domArea}" schema tables count')
def I_setup_the_database_connections_for_Oracle(context, schema, dbEnv, domArea):
    context.domainArea=domArea
    print("In Start of Setup <<--===COUNNECTION COUNT.... :", context.conCount)

    if (schema.lower() == 'staging'):
        context.staging = CommonFunctions.connect_db(schema, dbEnv)
    elif (schema.lower() == 'ingest'):
        context.ingest = CommonFunctions.connect_db(schema, dbEnv)
    elif (schema.lower() == 'exposure'):
        context.exposure = CommonFunctions.connect_db(schema, dbEnv)
    else:
       raise Exception("No connnections has been setup....!!!!!")

    print("COUNNECTION COUNT.... :", context.conCount)

@when(u'I execute following query for "{executeSchema}" Schema for table counting')
def I_execute_following_query_for_Schema_for_counting(context, executeSchema):
    if (executeSchema.lower() == 'staging'):
        context.stagingTableList=[]
        context.stagingRowList=[]
        staging_cursor = context.staging.cursor()
        staging_cursor.execute(context.text)
        context.stagingTableList = staging_cursor.fetchall()
        for row in context.stagingTableList:
           print("Processing Table Count..... :",row[0]+"."+row[1])
           stage_Stmt="select count(*) from "+row[0]+"."+row[1]
           staging_cursor.execute(stage_Stmt)
           rowCount=staging_cursor.fetchall();
           record=row + rowCount[0]
           #row.append(rowCount)
           context.stagingRowList.append(record)
        print("context.stagingRowList ===> ", context.stagingRowList)
        print("Context.stagingTableList ==>",context.stagingTableList)
        context.staging.close();
    elif (executeSchema.lower() == 'ingest'):
        context.ingestTableList=[]
        context.ingestRowList=[]
        ingest_cursor = context.ingest.cursor()
        ingest_cursor.execute(context.text)
        context.ingestTableList = ingest_cursor.fetchall()
        for row in context.ingestTableList:
           print("Processing Table Count..... :", row[0] + "." + row[1])
           ingest_Stmt="select count(*) from "+row[0]+"."+row[1]
           ingest_cursor.execute(ingest_Stmt)
           rowCount=ingest_cursor.fetchall();
           record=row + rowCount[0]
           context.ingestRowList.append(record)
        print("context.ingestRowList ===> ", context.ingestRowList)
        print("Context.ingestTableList ==>",context.ingestTableList)
    elif (executeSchema.lower() == 'exposure'):
        context.exposureTableList=[]
        context.exposureRowList=[]
        exposure_cursor = context.exposure.cursor()
        exposure_cursor.execute(context.text)
        context.exposureTableList = exposure_cursor.fetchall()
        for row in context.exposureTableList:
           print("Processing Table Count..... :", row[0] + "." + row[1])
           exposure_Stmt="select count(*) from "+row[0]+"."+row[1]
           exposure_cursor.execute(exposure_Stmt)
           rowCount=exposure_cursor.fetchall();
           record=row + rowCount[0]
           context.exposureRowList.append(record)
        print("context.exposureRowList ===> ", context.exposureRowList)
        print("Context.exposureTableList ==>",context.exposureTableList)

    else:
        print("No Query has been executed..!!")
    print("Query :", context.text)
    print("Schema Name : {}".format(executeSchema))
    print("<<---------------End of I execute following query...------------------------->>")

@then(u'I should get the counts of "{source1}","{source2}" against "{target}" in html format')
def I_should_get_the_counts_of_env1_env2_against_env3(context, source1,source2,target):
    print("<<<<=========<<<=========Into Formatting Results in HTML step=======>>>==========>> ")
    context.htmlTable=[]
    context.htmlRecord=[]
    if (target.lower()=='exposure'):
        context.htmlTable.append(['TableName', 'CCDEV-'+target, 'STABLE-'+source1, 'CCDEV-'+source2])
        if (source1.lower()=='staging' and source2.lower()=='ingest'):
            for rowExp in context.exposureRowList:
                context.htmlRecord.append(rowExp[0]+'.'+rowExp[1])
                print("rowExp[2] ==> :",rowExp[2])
                context.htmlRecord.insert(1,rowExp[2])
                isPresent=0
                for row in context.stagingRowList:
                    if(row[1].lower()==rowExp[1].lower()):
                        context.htmlRecord.insert(2,row[2])
                        isPresent=1
                        break;
                    else:
                        isPresent=0
                if(isPresent==0):
                    context.htmlRecord.insert(2,'0')
                else:
                    isPresent=0;
                for row in context.ingestRowList:
                    if (row[1].lower() == rowExp[1].lower()):
                        context.htmlRecord.insert(3, row[2])
                        isPresent = 1
                        break;
                    else:
                        isPresent=0
                if (isPresent == 0):
                    context.htmlRecord.insert(3,'0')
                else:
                    isPresent = 0;
                context.htmlTable.append(context.htmlRecord)
                context.htmlRecord=[]

            print("======########>>>>>>===Context.htmlTable:",context.htmlTable)

        else:
            print("*************Source1 and source2 are not matching...!!!*******")
    else:
        print("*************Target is not matching...!!!*******")

    CommonFunctions.write_html(context,context.domainArea,context.htmlTable)
