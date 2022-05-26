#!/bin/sh
##############################################################################
# This utility assist you in setting up your mangos database.                #
# This is a port of InstallDatabases.bat written by Antz for Windows         #
#                                                                            #
##############################################################################

OLDRELEASE="Rel21"
RELEASE="Rel22"
DUMP="NO"

dbname=""
dbcommand=""

createcharDB="YES"
createworldDB="YES"
createrealmDB="YES"

loadcharDB="YES"
loadworldDB="YES"
loadrealmDB="YES"
dbType="POPULATED"

updatecharDB="YES"
updateworldDB="YES"
updaterealmDB="YES"

addRealmList="YES"

svr_def="localhost"
user_def="mangos"
pass_def="mangos"
port_def="3306"
wdb_def="mangos0"
cdb_def="character0"
rdb_def="realmd"


determineDBName()
{
                dbname="MySQL"

}

mysqlconfigeditor()
{
        dbconfig="mysql_config_editor set --login-path=local --host=${svr_def} --port=${port_def} --user=${user_def} --password --skip-warn"
}

determineDBCommand()
{

                dbcommand="mysql --login-path=local -q -s"
      
}

createCharDB()
{
        printf "Creating Character database ${cdb_def}\n"
        $(${dbcommand} -e "Create database ${cdb_def}")

        if [ "${loadcharDB}" = "YES" ]; then
                loadCharDB
        fi
}

loadCharDB()
{
        printf "Loading data into character database ${cdb_def}\n"
        $(${dbcommand} ${cdb_def} < Character/Setup/characterLoadDB.sql)

        if [ "${updatecharDB}" = "YES" ]; then
                updateCharDB
        fi
}

updateCharDB()
{
        printf "Updating data into the character database ${cdb_def}\n"
        for file in $(ls Character/Updates/${OLDRELEASE}/*.sql | tr ' ' '|' | tr '\n' ' ')
        do
                file=$(echo ${file} | tr '|' ' ')
                printf "Applying update ${file}\n"
                ${dbcommand} "${cdb_def}" < "${file}"
                printf "File ${file} imported\n"
        done

        for file in $(ls Character/Updates/${RELEASE}/*.sql | tr ' ' '|' | tr '\n' ' ')
        do
                file=$(echo ${file} | tr '|' ' ')
                printf "Applying update ${file}\n"
                ${dbcommand} "${cdb_def}" < "${file}"
                printf "File ${file} imported\n"
        done
}

createWorldDB()
{
        printf "Creating World database ${wdb_def}\n"
        $(${dbcommand} -e "Create database ${wdb_def}")

        if [ "${loadworldDB}" = "YES" ]; then
                loadWorldDB
        fi
}

loadWorldDB()
{
        printf "Loading data into world database ${wdb_def}\n"
        $(${dbcommand} ${wdb_def} < World/Setup/mangosdLoadDB.sql)

        if [ "${dbType}" = "POPULATED" ]; then
                populateWorldDB
        fi
}

populateWorldDB()
{
        printf "Importing World database ${wdb_def}\n"
        for file in $(ls World/Setup/FullDB/${OLDRELEASE}/*.sql | tr ' ' '|' | tr '\n' ' ') 
        do
                file=$(echo ${file} | tr '|' ' ')
                printf "Importing file ${file}\n"
                $(${dbcommand} ${wdb_def} < ${file})
                printf "File ${file} imported\n"
        done

        for file in $(ls World/Setup/FullDB/*.sql | tr ' ' '|' | tr '\n' ' ') 
        do
                file=$(echo ${file} | tr '|' ' ')
                printf "Importing file ${file}\n"
                $(${dbcommand} ${wdb_def} < ${file})
                printf "File ${file} imported\n"
        done
}

updateWorldDB()
{
    printf "Updating data into the World database ${wdb_def}\n"
    for file in World/Updates/${OLDRELEASE}/*.sql
    do
        printf "Applying update ${file}\n"
        ${dbcommand} "${wdb_def}" < "${file}"
        printf "File ${file} imported\n"
    done

    for file in World/Updates/${RELEASE}/*.sql
    do
        printf "Applying update ${file}\n"
        ${dbcommand} "${wdb_def}" < "${file}"
        printf "File ${file} imported\n"
    done
}

createRealmDB()
{
        printf "Creating realm database ${rdb_def}\n"
        $(${dbcommand} -e "Create database ${rdb_def}")

        if [ "${loadrealmDB}" = "YES" ]; then
                loadRealmDB
        fi
}

loadRealmDB()
{
        printf "Loading data into realm database ${rdb_def}\n"
        $(${dbcommand} ${rdb_def} < Realm/Setup/realmdLoadDB.sql)
}

updateRealmDB()
{
        printf "Updating data into the Realm database ${rdb_def}\n"
        for file in $(ls Realm/Updates/${OLDRELEASE}/*.sql | tr ' ' '|' | tr '\n' ' ')
        do
                file=$(echo ${file} | tr '|' ' ')
                printf "Applying update ${file}\n"
                $(${dbcommand} ${rdb_def} < ${file})
                printf "File ${file} imported\n"
        done

        for file in $(ls Realm/Updates/${RELEASE}/*.sql | tr ' ' '|' | tr '\n' ' ')
        do
                file=$(echo ${file} | tr '|' ' ')
                printf "Applying update ${file}\n"
                $(${dbcommand} ${rdb_def} < ${file})
                printf "File ${file} imported\n"
        done
}

addRealmList()
{
        printf "Adding realm list entries\n"
        $(${dbcommand} ${rdb_def} < Tools/updateRealm.sql)
}

activity=""





determineDBName


        mysqlconfigeditor
        $dbconfig

determineDBCommand


if [ "${createcharDB}" = "YES" ]; then
        createCharDB
fi

if [ "${createworldDB}" = "YES" ]; then
        createWorldDB
fi

if [ "${createrealmDB}" = "YES" ]; then
        createRealmDB
fi

if [ "${updateworldDB}" = "YES" ]; then
        updateWorldDB
fi

if [ "${updaterealmDB}" = "YES" ]; then
        updateRealmDB
fi

if [ "${addRealmList}" = "YES" ]; then
        addRealmList
fi

if [ "${DUMP}" = "YES" ]; then
        printf "Dumping database information...\n"
        echo "${svr};${port};${user};${pass};${rdb}" > ~/db.conf
        echo "${svr};${port};${user};${pass};${wdb}" >> ~/db.conf
        echo "${svr};${port};${user};${pass};${cdb}" >> ~/db.conf
fi

printBanner
printf "Database creation and load complete :-)\n"
printf "\n"
