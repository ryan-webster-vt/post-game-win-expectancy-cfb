FROM public.ecr.aws/lambda/python:3.13

# Copy requirements and install
COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

# Copy your Python source code
COPY src/* ${LAMBDA_TASK_ROOT}/

# Set the Lambda handler
CMD ["main.lambda_handler"]
