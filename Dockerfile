FROM python:3.10.14-bookworm

RUN pip install --upgrade pip

COPY drug_molecule_generator /app/drug_molecule_generator

WORKDIR /app

# RUN pip install -r /app/drug_molecule_generator/Requirements.txt
RUN pip install --no-cache-dir -r /app/drug_molecule_generator/Requirements.txt

ENV PYTHONPATH=${PYTHONPATH}:/app/drug_molecule_generator

RUN chmod +x /app/drug_molecule_generator/train_pipeline.py

RUN chmod +x /app/drug_molecule_generator/predict.py

ENTRYPOINT [ "python3" ]

CMD [ "./drug_molecule_generator/train_pipeline.py" ]

