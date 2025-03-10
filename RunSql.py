import psycopg2

db = psycopg2.connect(dbname='transportation_system', user='postgres', password='', host='localhost')
cursor = db.cursor()


def executeScriptsFromFile(filename):
    # Open and read the file as a single buffer
    fd = open(filename, 'r')
    sqlFile = fd.read()
    fd.close()

    # all SQL commands (split on ';')
    sqlCommands = sqlFile.split(';')
    del sqlCommands[len(sqlCommands)-1]

    # Execute every command from the input file
    for command in sqlCommands:
        # This will skip and report errors
        # For example, if the tables do not yet exist, this will skip over
        # the DROP TABLE commands
        cursor.execute(command)
    db.commit()