def delete_elements_from_list(elements_to_delete, list: list):
    """
    It deletes all the elements in elements_to_delete, which is a string
    with many values separated by ',', from list, and returns the clean list.
    """

    elements_to_delete = elements_to_delete.split(',')
    if elements_to_delete[0].lower()=="delete none":
        return list
    for erase in elements_to_delete:
        for n,el in enumerate(list):
            if erase in el:
                del list[n]
    return list


def list_to_dictionary(list_text, separator):
    """
    From a list with values in a type like -> word:wordvalue, return
    a dictionary where word is the key and wordvalue the value, : can be any value
    given in separator.
    """

    dictionary = {}
    for el in list_text:
        if separator in el:
            list_words =  el.split(separator)
            word1 = list_words[0].strip()
            word2 = list_words[1].strip()
            dictionary.update({word1:word2})
    return dictionary



 
