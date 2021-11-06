FROM public.ecr.aws/lambda/python:3.8

RUN yum -y update
RUN yum -y install unixODBC unixODBC-devel

# add your python packages here
RUN pip install --use-feature=2020-resolver awslambdaric boto3 boto3_type_annotations pandas pyarrow s3fs requests beautifulsoup4

# copy all python files
COPY *.py ./

# RUN python delete-folder.py --directory /var/task/packages/sklearn --pattern tests
CMD [ "entry.handler" ]