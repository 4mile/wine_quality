FROM tensorflow/tensorflow

RUN pip install jupyter_kernel_gateway datalab

# datalab clobbers the existing h5py or something, so it needs to be upgraded manually
RUN pip install --upgrade h5py

# https://github.com/tensorflow/tensorflow/issues/2746#issuecomment-225021795
RUN pip uninstall --yes six
RUN pip install six --upgrade --target="/usr/lib/python2.7/dist-packages"

RUN jupyter nbextension install --log-level=WARN --py google.datalab.notebook
RUN jupyter nbextension install --log-level=WARN --py datalab.notebook

WORKDIR /notebooks
COPY *.ipynb ./
COPY jupyter_kernel_gateway_config.py /root/.jupyter/

EXPOSE 8888
CMD ["jupyter", "kernelgateway"]
