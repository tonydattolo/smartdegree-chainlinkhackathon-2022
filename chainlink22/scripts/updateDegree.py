from brownie import (
    accounts,
    config,
    SmartDegree,
    network
)
from scripts.utils import get_account
from dotenv import load_dotenv
load_dotenv()

def updateDegree():
    studentAccount = get_account('studentTestAccount')
    multiversityAccount = get_account('multiversityTestAccount')
    instructorAccount = get_account('instuctorTestAccount')
    employerAccount = get_account('employerTestAccount')
    smartDegree = SmartDegree[0]

    currentCoursesCompleted = smartDegree.getCoursesCompleted()
    print(f'{currentCoursesCompleted=}')

    storeCompletedCourse = smartDegree.addCourseCompleted(
        instructorAccount,
        "CS 101",
        "Intro to Computer Science, Programming, and Web3", 
        {'from': instructorAccount},
        )
    storeCompletedCourse.wait(1)

    currentCoursesCompleted = smartDegree.getCoursesCompleted()
    print(f'{currentCoursesCompleted=}')

def main():
    updateDegree()