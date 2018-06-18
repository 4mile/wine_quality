# Looker + Tensorflow + WebHook prediction example

### Requirements

- Docker

### Getting started

1. [Get Google Cloud credentials](https://cloud.google.com/bigquery/docs/reference/libraries) and save the JSON credentials file as `service_key.json` in this directory.

1. Update `Dockerfile` and change the `PROJECT_ID` to match your project ID.

1. Build the Docker image:
        
        docker build --tag wine_quality .

1. View and edit the notebooks by running this command, then go to the URL it prints out:

        docker run -it --rm -p 8888:8888 -v $PWD:/notebooks wine_quality jupyter notebook --allow-root

1. Start the WebHook server by mounting the current directory as `/notebooks`, then use something like [ngrok.io](https://ngrok.com/) to expose your server to the outside world and point your Looker schedule to the webhook at `https://<yourname>.ngrok.io/predict`:

        docker run -it --rm -p 1234:8888 -v $PWD:/notebooks wine_quality
