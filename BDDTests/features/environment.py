
def before_all(context):
    print("before all ...!")
    context.conCount=0;
def after_all(context):
    # if context.staging!=None:
    #     context.staging.close()
    # if context.ingest!=None:
    #     context.ingest.close();
    # if context.exposure!=None:
    #     context.exposure.close();
    # if context.source_con!=None:
    #     context.source_con.close();
    # if context.target_con!=None:
    #     context.target_con.close();

    print("after all ...!")
# def before_feature(context, feature):
#     model.init(environment='test')