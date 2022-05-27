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
    studentAccount = get_account('rinkebyTest1Student')
    instructorAccount = get_account('rinkebyTest4Instructor')
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