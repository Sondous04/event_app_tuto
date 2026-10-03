FROM public.ecr.aws/lambda/nodejs:20
COPY package*.json ${LAMBDA_TASK_ROOT}/
RUN npm ci --omit=dev
COPY app.js events.js index.js utils.js ${LAMBDA_TASK_ROOT}/
CMD ["index.handler"]