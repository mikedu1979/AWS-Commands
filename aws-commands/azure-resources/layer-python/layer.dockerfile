FROM lambci/lambda:build-python3.8

WORKDIR /var/task
RUN yum -y update
RUN yum -y install unixODBC unixODBC-devel

# add your python packages here
RUN pip install boto3_type_annotations pandas pyarrow s3fs requests beautifulsoup4 -t python/

# you can use delete-folder.py to remove extra tests in Python Packages
# COPY delete-folder.py .
# RUN python delete-folder.py --directory /var/task/python/sklearn --pattern tests

WORKDIR /var/task

# Compress all source codes.

RUN zip -r9 -q /var/task/layer.zip .

CMD ["/bin/bash"]
