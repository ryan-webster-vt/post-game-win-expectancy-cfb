# Lambda Python 3.13 base image
FROM public.ecr.aws/lambda/python:3.13

# Install precompiled packages (no gcc needed)
RUN pip3.13 install --no-cache-dir \
    scikit-learn \
    numpy \
    joblib \
    pyarrow \
    boto3

# Copy your Lambda function
COPY lambda_function.py ${LAMBDA_TASK_ROOT}/

# Set the Lambda handler
CMD ["execute_model.lambda_handler"]
