FROM lambci/lambda:build-python3.8

WORKDIR /var/task
RUN yum -y update
RUN yum -y install unixODBC unixODBC-devel

# add your python packages here
RUN pip install boto3 boto3_type_annotations pandas pyarrow s3fs requests beautifulsoup4 --use-feature=2020-resolver

# copy all python files
COPY *.py .
# RUN python delete-folder.py --directory /var/task/packages/sklearn --pattern tests
