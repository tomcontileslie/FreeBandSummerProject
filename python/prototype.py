# Given a string x representing a free band element, return its content
#  defined as the set of letters that occur in it
def content_of_string(x):
    content = set()
    for char in x:
        if not char in content:
            content.add(char)
    return content

a = "aabcdcdabcacd"
print(content_of_string(a))
