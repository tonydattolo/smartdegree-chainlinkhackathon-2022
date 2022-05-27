from brownie import (
    accounts,
    config,
    SmartDegree,
    network
)
from dotenv import load_dotenv
load_dotenv()

def get_account(configWalletName):
    # check if active network is development (ganache)
    if network.show_active() == "development":
        return accounts[0]
    # if it's an active testnet, we need an actual account
    else:
        return accounts.add(config['wallets'][f'{configWalletName}'])

def deployAndTestLocal():
    studentAccount = accounts[0]
    instructorAccount = accounts[1]
    smartDegree = SmartDegree.deploy({'from': studentAccount}) # accessing SimpleStorage.sol
    # Transact
    # Call
    currentCoursesCompleted = smartDegree.getCoursesCompleted()
    print(f'{currentCoursesCompleted=}')
    
    
    storeCompletedCourse = smartDegree.addCourseCompleted(
        instructorAccount,
        "CS 101",
        "Intro to CS Example", 
        {'from': studentAccount},
        )
    storeCompletedCourse.wait(1)
    
    currentCoursesCompleted = smartDegree.getCoursesCompleted()
    
    print(f'{currentCoursesCompleted=}')

def deployAndTestRinkeby():
    studentAccount = get_account('rinkebyTest1Student')
    instructorAccount = get_account('rinkebyTest4Instructor')
    smartDegree = SmartDegree.deploy({'from': studentAccount}) # accessing SimpleStorage.sol
    # Transact
    # Call
    currentCoursesCompleted = smartDegree.getCoursesCompleted()
    print(f'{currentCoursesCompleted=}')
    
    
    storeCompletedCourse = smartDegree.addCourseCompleted(
        instructorAccount,
        "CS 101",
        "Computer Science 1", 
        {'from': studentAccount},
        )
    storeCompletedCourse.wait(1)
    
    currentCoursesCompleted = smartDegree.getCoursesCompleted()
    
    print(f'{currentCoursesCompleted=}')

def updateRinkeyby():
    studentAccount = get_account('rinkebyTest1Student')
    instructorAccount = get_account('rinkebyTest4Instructor')
    smartDegree = SmartDegree[-1]

    currentCoursesCompleted = smartDegree.getCoursesCompleted()
    print(f'{currentCoursesCompleted=}')

    storeCompletedCourse = smartDegree.addCourseCompleted(
        instructorAccount,
        "CS 201",
        "Object Oriented Programming", 
        {'from': instructorAccount},
        )
    storeCompletedCourse.wait(1)

    currentCoursesCompleted = smartDegree.getCoursesCompleted()
    print(f'{currentCoursesCompleted=}')


def deploySmartDegree():
    studentAccount = accounts[0]
    smartDegree = SmartDegree.deploy({'from': studentAccount}) # accessing SimpleStorage.sol
    # Transact
    # Call
    currentCoursesCompleted = smartDegree.getCoursesCompleted()
    print(f'{currentCoursesCompleted=}')
    
    
    storeValueTx = simpleStorage.store(666, {'from': account})
    storeValueTx.wait(1)
    
    currentStoredValue = simpleStorage.retrieve()
    
    print(f'{currentStoredValue=}')



def main():
    deployAndTestLocal()