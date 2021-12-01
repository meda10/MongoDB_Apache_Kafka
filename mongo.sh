#!/bin/bash

echo "\nMONGO\n"

echo -e "\nConfiguring the MongoDB ReplicaSet.\n"
docker-compose exec mongo1 /usr/bin/mongo --eval '''if (rs.status()["ok"] == 0) {
    rsconf = {
      _id : "rs0",
      members: [
        { _id : 0, host : "mongo1:27017", priority: 1.0 },
        { _id : 1, host : "mongo2:27017", priority: 0.5 },
        { _id : 2, host : "mongo3:27017", priority: 0.5 }
      ]
    };
    rs.initiate(rsconf);
}

rs.conf();'''


docker-compose exec mongo1 mongo volby --eval 'db.runCommand({ insert: "lidi", documents: [
{ "name": "Miloslava Cechnerová", "id": "P100","strana": "NE" },
{ "name": "Milada Weintragerová", "id": "P101","strana": "NE" },
{ "name": "Michaela Alexandrová", "id": "P102","strana": "NE" },
{ "name": "Ladislava Šafrová", "id": "P103","strana": "NE" },
{ "name": "Stanislav Kurej", "id": "P104","strana": "NE" },
{ "name": "Marcela Horká", "id": "P105","strana": "NE" },
{ "name": "Jana Bušková", "id": "P106","strana": "NE" },
{ "name": "Jaroslav Hložek", "id": "P107","strana": "NE" },
{ "name": "Jarmila Klemešová", "id": "P108","strana": "NE" },
{ "name": "Jolana Hutáková", "id": "P109","strana": "NE" },
{ "name": "Karla Marková", "id": "P200", "strana": "Proti sobě" },
{ "name": "Josef Lisický", "id": "P201", "strana": "Proti sobě" },
{ "name": "Alice Dvořáková", "id": "P202", "strana": "Proti sobě" },
{ "name": "Marek Bentsa", "id": "P203", "strana": "Proti sobě" },
{ "name": "Zuzana Hašková", "id": "P204", "strana": "Proti sobě" },
{ "name": "Věra Segethová", "id": "P205", "strana": "Proti sobě" },
{ "name": "André Popovych", "id": "P206", "strana": "Proti sobě" },
{ "name": "Pavel Pilnaj", "id": "P207", "strana": "Proti sobě" },
{ "name": "Vítězslav Šimků", "id": "P208", "strana": "Proti sobě" },
{ "name": "Eva Kolbeová", "id": "P209", "strana": "Proti sobě" },
{ "name": "Jiří Picka", "id": "P300", "strana": "Námořníci" },
{ "name": "Petr Vrabec", "id": "P301", "strana": "Námořníci" },
{ "name": "Marie Dubová", "id": "P302", "strana": "Námořníci" },
{ "name": "Miluše Poulíčková", "id": "P303", "strana": "Námořníci" },
{ "name": "Terezie Slavíková", "id": "P304", "strana": "Námořníci" },
{ "name": "Radek Kalkuš", "id": "P305", "strana": "Námořníci" },
{ "name": "Václav Korbel", "id": "P306", "strana": "Námořníci" },
{ "name": "Dumitru Oberdörfer", "id": "P307", "strana": "Námořníci" },
{ "name": "Jitka Špačková", "id": "P308", "strana": "Námořníci" },
{ "name": "Zdeněk Weinfurt", "id": "P309", "strana": "Námořníci" },
{ "name": "Jan Ježek", "id": "P400", "strana": "Zaseklý blok" },
{ "name": "Miroslav Dvorník", "id": "P401", "strana": "Zaseklý blok" },
{ "name": "Petru Staněk", "id": "P402", "strana": "Zaseklý blok" },
{ "name": "Martin Novohradský", "id": "P403", "strana": "Zaseklý blok" },
{ "name": "Yveta Honcová", "id": "P404", "strana": "Zaseklý blok" },
{ "name": "Kristýna Martynková", "id": "P405", "strana": "Zaseklý blok" },
{ "name": "František Mužík", "id": "P406", "strana": "Zaseklý blok" },
{ "name": "Matej Fiala", "id": "P407", "strana": "Zaseklý blok" },
{ "name": "Antonín Jíra", "id": "P408", "strana": "Zaseklý blok" },
{ "name": "Zdeňka Keková", "id": "P409", "strana": "Zaseklý blok" },
{ "name": "Božena Malinková", "id": "P500", "strana": "Lež" },
{ "name": "Kateřina Havlová", "id": "P501", "strana": "Lež" },
{ "name": "Ľudmila Rušarová", "id": "P502", "strana": "Lež" },
{ "name": "Žaneta Trllová", "id": "P503", "strana": "Lež" },
{ "name": "Oldřich Skalník", "id": "P504", "strana": "Lež" },
{ "name": "Dan Florián", "id": "P505", "strana": "Lež" },
{ "name": "Ilona Ziegelbauerová", "id": "P506", "strana": "Lež" },
{ "name": "Zdenka Čutková", "id": "P507", "strana": "Lež" },
{ "name": "Adéla Bartáková", "id": "P508", "strana": "Lež" },
{ "name": "Karel Maďar", "id": "P509", "strana": "Lež" },
{ "name": "Lucie Vápeníková", "id": "P600", "strana": "Prezidenti" },
{ "name": "Martina Kozelková", "id": "P601", "strana": "Prezidenti" },
{ "name": "Tomáš Minařík", "id": "P602", "strana": "Prezidenti" },
{ "name": "Pavla Záškolná", "id": "P603", "strana": "Prezidenti" },
{ "name": "Ludmila Straková", "id": "P604", "strana": "Prezidenti" },
{ "name": "Soňa Košková", "id": "P605", "strana": "Prezidenti" },
{ "name": "Veronika Malochová", "id": "P606", "strana": "Prezidenti" },
{ "name": "Miroslava Brabencová", "id": "P607", "strana": "Prezidenti" },
{ "name": "Renata Sembolová", "id": "P608", "strana": "Prezidenti" },
{ "name": "Lenka Petržilková", "id": "P609", "strana": "Prezidenti" },
{ "name": "Petra Vaňková", "id": "P700", "strana": "Zavřeme česko" },
{ "name": "Ondřej Fousek", "id": "P701", "strana": "Zavřeme česko" },
{ "name": "Michal Svatoš", "id": "P702", "strana": "Zavřeme česko" },
{ "name": "Irena Menšíková", "id": "P703", "strana": "Zavřeme česko" },
{ "name": "Jaromíra Duongová", "id": "P704", "strana": "Zavřeme česko" },
{ "name": "Anna Červenková", "id": "P705", "strana": "Zavřeme česko" },
{ "name": "Dominik Škrobánek", "id": "P706", "strana": "Zavřeme česko" },
{ "name": "Lukáš Vladař", "id": "P707", "strana": "Zavřeme česko" },
{ "name": "Vladislav Kulich", "id": "P708", "strana": "Zavřeme česko" },
{ "name": "Silvie Musilová", "id": "P709", "strana": "Zavřeme česko" },
{ "name": "Roman Reinberk", "id": "P800", "strana": "Levý blok" },
{ "name": "Aleš Bihary", "id": "P801", "strana": "Levý blok" },
{ "name": "Jozef Novotný", "id": "P802", "strana": "Levý blok" },
{ "name": "Dušan Tůma", "id": "P803", "strana": "Levý blok" },
{ "name": "Vladimír Tocauer", "id": "P804", "strana": "Levý blok" },
{ "name": "Radka Chládková", "id": "P805", "strana": "Levý blok" },
{ "name": "Milan Ronza", "id": "P806", "strana": "Levý blok" },
{ "name": "Květuše Pučálková", "id": "P807", "strana": "Levý blok" },
{ "name": "Yuriy Hruška", "id": "P808", "strana": "Levý blok" },
{ "name": "Alena Kropáčková", "id": "P809", "strana": "Levý blok" },
{ "name": "Jaroslava Brzobohatá", "id": "P900", "strana": "Teenager 21" },
{ "name": "David Talaš", "id": "P901", "strana": "Teenager 21" },
{ "name": "Barbora Novotná", "id": "P902", "strana": "Teenager 21" },
{ "name": "Ludvík Bradáč", "id": "P903", "strana": "Teenager 21" },
{ "name": "Markéta Frömlová", "id": "P904", "strana": "Teenager 21" },
{ "name": "Vlastimila Krpelová", "id": "P905", "strana": "Teenager 21" },
{ "name": "Vlasta Frydryšková", "id": "P906", "strana": "Teenager 21" },
{ "name": "Ladislav Šuster", "id": "P907", "strana": "Teenager 21" },
{ "name": "Lien Urbancová", "id": "P908", "strana": "Teenager 21" },
{ "name": "Dagmar Volná", "id": "P909", "strana": "Teenager 21" }
]})'


docker-compose exec mongo1 mongo volby --eval 'db.runCommand({ insert: "strany", documents: [
{ "strana": "NE", "color": "rgb(255,0,0)" },
{ "strana": "Proti sobě", "color": "rgb(255,128,0)" },
{ "strana": "Námořníci", "color": "rgb(255,255,0)" },
{ "strana": "Zaseklý blok", "color": "rgb(0,255,0)" },
{ "strana": "Lež", "color": "rgb(0,255,255)" },
{ "strana": "Prezidenti", "color": "rgb(0,0,255)" },
{ "strana": "Zavřeme česko", "color": "rgb(172,0,255)" },
{ "strana": "Levý blok", "color": "rgb(255,0,255)" },
{ "strana": "Teenager 21", "color": "rgb(128,128,128)" },
]})'

