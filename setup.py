from setuptools import setup

setup(
    name='ContentPipeline',
    author='KSyed',
    description='Query different tables for ContentPieplein Project',
    packages=['BDDCommon',
              'BDDCommon.CommonFuncs',
              'BDDTests',
              'BDDTests.features',
              'BDDTests.features.Ontology',
              'BDDTests.features.steps']
)