"""
This is a module to handle a GOM type file, which is a file with .json extension that is present in the Omnitracs devices to monitor 
different kinds of events that occour in the different modules of the device.
"""

import json


def get_gom_latest_event(jsonpath):
    """ It will return the latest gom event of the given json/gom file.

    Parameters
    ----------
    jsonpath: str
        Path of the json file to extract the latest gom event.

    Returns
    -------
    iterable object
        A dictionary which contains the latest gom event information.
    """
    f = open(jsonpath, 'r')
    data = json.load(f)
    return data["Observation"]["Events"]["LatestEvent"]

def get_gom_latest_event_key_value(jsonpath, key):
    """ It will return a key value from the latest gom observation of the given json/gom file.

    Parameters
    ----------
    jsonpath: str
        Path of the json file to extract the latest gom event.
    key: str
        The key of the desired value.

    Returns
    -------
    str
        The value requested by the parameter_key.
    """
    latest_event = get_gom_latest_event(jsonpath)
    return latest_event[key]

def get_nth_gom_event(jsonpath, nth_event):
    """ It will return the nth gom event of the given json/gom file.

    Parameters
    ----------
    jsonpath: str
        Path of the json file to extract the nth gom event.

    Returns
    -------
    iterable object
        The nth event present in the gom file (json file).
    """
    f = open(jsonpath, 'r')
    data = json.load(f)
    return data["Observation"]["Events"]["Event"][nth_event]

def get_gom_nth_event_key_value(jsonpath, nth_event, key):
    """ It will return a key value from the nth event of the given json/gom file.

    Parameters
    ----------
    jsonpath: str
        Path of the json file to extract the latest gom event.

    nth_event: int
        The number of the event to retrieve. Starting from 1.

    key: str
        The key of the desired value.

    Returns
    -------
    str
        The value of the requested key.
    """
    numberofevents = count_gom_existing_events(jsonpath)
    numberofevents_without_lastest = numberofevents - 1
    if nth_event > numberofevents_without_lastest:
        print(f"{nth_event} is not a valid event, valid events are from 1 to {numberofevents_without_lastest}")
        return "Invalid number of event"
    elif nth_event < 1:
        print(f"{nth_event} is not a valid event, valid events are from 1 to {numberofevents_without_lastest}")
        return "Invalid number of event"
    nth_selected_event = get_nth_gom_event(jsonpath, nth_event-1)
    return nth_selected_event[key]

def get_gom_oldest_event_key_value(jsonpath, key):
    """ It will return a key value from the nth event of the given json/gom file.

    Parameters
    ----------
    jsonpath: str
        Path of the json file to extract the latest gom event.

    key: str
        The key of the desired value.

    Returns
    -------
    str
        The value of the requested key.
    """
    numberofevents = count_gom_existing_events(jsonpath)
    #minus two because count_gom_total_events includes the latest event and start the count from 1
    oldest_event = get_nth_gom_event(jsonpath, numberofevents-2)
    return oldest_event[key]

def count_gom_existing_events(jsonpath):
    """ It will return the count of all the existing events from the given json/gom file.
    So it includes the latest event an the older ones too.

    Parameters
    ----------
    jsonpath: str
        Path of the json file to extract the latest gom event.

    Returns
    -------
    int
        The count of the events.
    """
    f = open(jsonpath, 'r')
    data = json.load(f)
    events_array = data["Observation"]["Events"]["Event"]
    #plus 1 for the latest event
    return len(events_array)+1