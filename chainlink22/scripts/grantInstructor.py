from brownie import (
    accounts,
    config,
    SmartDegree,
    network
)
from scripts.utils import get_account
from dotenv import load_dotenv
load_dotenv()

def grant():
    studentAccount = get_account('studentTestAccount')
    multiversityAccount = get_account('multiversityTestAccount')
    instructorAccount = get_account('instuctorTestAccount')
    employerAccount = get_account('employerTestAccount')
    smartDegree = SmartDegree[0]

    smartDegree.grantRole(
        "INSTRUCTOR_ROLE",
        instructorAccount,
        {'from': multiversityAccount}
    )
    


def main():
    grant()