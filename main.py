from fastapi import FastAPI
import pandas as pd
import numpy as np
from fastapi.middleware.cors import CORSMiddleware
import uvicorn
from pydantic import BaseModel
import random


from drug_molecule_generator.config import config
from drug_molecule_generator.preprocessing.data_management import load_dataset, load_nn_model, save_model
import drug_molecule_generator.preprocessing.preprocessor as pp
from drug_molecule_generator.predict import generate_molecule

saved_file_name = config.MODEL_FILE_NAME

loaded_model = load_nn_model(saved_file_name)


cv_data = load_dataset(config.TEST_FILE)
preprocess = pp.preprocess_data()
preprocess.fit()
X_cv,_ = preprocess.transform(cv_data["X"], cv_data["Y"])

app = FastAPI(title="Drug Molecule Discovery API",
              description="An API to randomly generate a chemical formula of a valid drug molecule",
              version="0.1")

origins = ["*"]

app.add_middleware(CORSMiddleware,allow_origins=origins,
                   allow_credentials=True,
                   allow_methods=["*"],
                   allow_headers=["*"])


class MoleculeGenerator(BaseModel):
    user_input: str


@app.get("/")
def index():
    return {"message":"An app for generating chemical formula of a valid drug molecule"} 


@app.post("/Generate Molecule")
def gen_molecule(trigger: MoleculeGenerator):

    input = trigger.user_input

    if input == "y" or input == "Y" or input == "start" or input == "Start":
        single_input = X_cv[random.randint(0,X_cv.shape[0]),:]
        single_input = single_input.reshape(1,single_input.shape[0])
        gen_mol = generate_molecule(single_input,1)

        return gen_mol



if __name__ == "__main__":
    uvicorn.run(app)