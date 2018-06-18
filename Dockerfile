FROM tensorflow/tensorflow

RUN pip install jupyter_kernel_gateway datalab

# datalab clobbers the existing h5py or something, so it needs to be upgraded manually
RUN pip install --upgrade h5py

# https://github.com/tensorflow/tensorflow/issues/2746#issuecomment-225021795
RUN pip uninstall --yes six
RUN pip install six --upgrade --target="/usr/lib/python2.7/dist-packages"

# '%load_ext' is still required in the notebooks. I've tried to load the extensions automatically
# through jupyter_notebook_config.py but get lots of errors.
RUN jupyter nbextension install --log-level=WARN --py google.datalab.notebook
RUN jupyter nbextension install --log-level=WARN --py datalab.notebook

# You must provide a credentials file. See https://cloud.google.com/bigquery/docs/reference/libraries
COPY service_key.json /root/service_key.json
ENV GOOGLE_APPLICATION_CREDENTIALS=/root/service_key.json

# Change this project ID to your Google Cloud project ID.
ENV PROJECT_ID=looker-action-hub

WORKDIR /notebooks
COPY *.ipynb ./
COPY jupyter_kernel_gateway_config.py /root/.jupyter/
RUN mkdir -p /root/.config/gcloud && echo "{\"project_id\":\"$PROJECT_ID\"}" > /root/.config/gcloud/config.json

EXPOSE 8888
CMD ["jupyter", "kernelgateway"]
