from brownie import (
    accounts,
    config,
    SmartDegree,
    network
)
from scripts.utils import get_account
from dotenv import load_dotenv
load_dotenv()

def updateRinkeyby():
    studentAccount = get_account('studentTestAccount')
    multiversityAccount = get_account('multiversityTestAccount')
    instructorAccount = get_account('instuctorTestAccount')
    employerAccount = get_account('employerTestAccount')
    smartDegree = SmartDegree[-1]

    currentCoursesCompleted = smartDegree.getCoursesCompleted()
    print(f'{currentCoursesCompleted=}')

    storeCompletedCourse = smartDegree.addCourseCompleted(
        instructorAccount,
        "CS 500",
        "Intro to Web3 Software Engineering", 
        {'from': instructorAccount},
        )
    storeCompletedCourse.wait(1)

    currentCoursesCompleted = smartDegree.getCoursesCompleted()
    print(f'{currentCoursesCompleted=}')

def main():
    updateRinkeyby()