import sys

try:
    VM_count = sys.argv[1]
except IndexError:
    print("VM_count was not specified")
    exit()

#Impiorts from Jinja2
from jinja2 import Environment, FileSystemLoader
 
#Load Jinja2 template
env = Environment(loader = FileSystemLoader('./'), trim_blocks=True, lstrip_blocks=True)
template = env.get_template('template.j2')
 
with open('out.yaml', 'w') as fh:
    fh.write(template.render(
        limit = int(VM_count)
    ))
