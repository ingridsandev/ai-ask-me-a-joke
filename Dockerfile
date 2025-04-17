# Use the official AWS Lambda Python runtime as the base image
FROM public.ecr.aws/lambda/python:3.9

# Copy the main function code into the container
COPY src/main.py ${LAMBDA_TASK_ROOT}

# Install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

# Command to run the Lambda function
CMD ["main.lambda_handler"]