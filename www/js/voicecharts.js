const axios = require('axios');

var partiesNames = [];
var partiesVotes = [];
var partiesColors = [];
window.allParties = [];
window.allKraje = [];
window.allPossibleVoices = 0;
window.allPossibleVoicesRegion = 0;
window.voicesCount = 0;
window.regionPeopleCount = 0;
window.allPeopleCount = 0;


window.findAllParties = function() {
    axios.get('http://localhost:5000/strany', {}).then(function (response) {
        response.data.forEach((element) => {
            allParties.push(element);
        });
        findAllKraje();
        findAllVoicesPossible();
    }).catch(function (error) {
        console.log(error);
    });
}


window.findAllKraje = function() {
    axios.get('http://localhost:5000/kraje', {}).then(function (response) {
        response.data.forEach((element) => {
            allKraje.push(element);
        });

        const urlParams = new URLSearchParams(window.location.search);
        const regionCode = urlParams.get('kraj');

        if (regionCode !== null) {
            changeRegionName(regionCode);
            refreshChart2(regionCode);
        } else {
            refreshChart();
        }

    }).catch(function (error) {
        console.log(error);
    });
}


window.findAllVoicesPossible = function() {
    const urlParams = new URLSearchParams(window.location.search);
    const regionCode = urlParams.get('kraj');

    if (regionCode !== null) {
        axios.get('http://localhost:5000/hlasuMaxCelkemKraj/' + regionCode).then(function (response) {
            var voices = response.data[0].maxPocetHlasu;
            regionPeopleCount = response.data[0].pocetVolicu;
            allPossibleVoicesRegion = voices;
            findVoicesCountedRegion(regionCode);
        }).catch(function (error) {
            console.log(error);
        });
    } else {
        axios.get('http://localhost:5000/hlasuMaxCelkem').then(function (response) {
            var voices = response.data[0].total;
            allPeopleCount = response.data[0].totalPeople;
            allPossibleVoices = voices;
            findVoicesCounted();
        }).catch(function (error) {
            console.log(error);
        });
    }
}


window.findVoicesCounted = function() {
    axios.get('http://localhost:5000/hlasuCelkem').then(function (response) {
        var voices = response.data[0].total;
        voicesCount = voices;
        setUcast(allPossibleVoices, allPeopleCount, voicesCount, false);
    }).catch(function (error) {
        console.log(error);
    });
}


window.findVoicesCountedRegion = function(regionCode) {
    axios.get('http://localhost:5000/krajHlasuCelkem/' + regionCode).then(function (response) {
        var voices = response.data[0].total;
        voicesCount = voices;
        setUcast(allPossibleVoicesRegion, regionPeopleCount, voicesCount, true);
    }).catch(function (error) {
        console.log(error);
    });
}


window.setUcast = function(allVoices, allPeople, countedVoices, region) {
    var percentSpan;
    if (region) {
        percentSpan = document.getElementById('info-participation-percent-kraj');
        percentSpanTotal = document.getElementById('info-summed-percent-kraj');
    } else {
        percentSpan = document.getElementById('info-participation-percent-cr');
        percentSpanTotal = document.getElementById('info-summed-percent-cr');
    }

    var percent = countedVoices / allVoices * 100;
    percent = Math.round(percent * 100) / 100;
    percentSpan.innerHTML = percent + "%";

    var percentTotal = countedVoices / allPeople * 100;
    percentTotal = Math.round(percentTotal * 100) / 100;
    percentSpanTotal.innerHTML = percentTotal + "%";
}


window.refreshChart = function() {
    partiesNames = [];
    partiesVotes = [];
    partiesColors = [];
    var parties = [];

    axios.get('http://localhost:5000/cr', {}).then(function (response) {
        var data = response.data;
        data.forEach((element) => {
                var color = allParties.filter(e => e.strana === element._id)[0];
                if (color !== undefined) {
                    partiesNames.push(element._id);
                    partiesVotes.push(element.COUNT);
                    partiesColors.push(color.color);
                }
            }
        );

        repaintChart('myChart');
        refreshMap();
    }).catch(function (error) {
        console.log(error);
    });
}

window.refreshChart2 = function(idKraje) {
    partiesNames = [];
    partiesVotes = [];
    partiesColors = [];
    var parties = [];

    axios.get('http://localhost:5000/kraj/' + idKraje).then(function (response) {
        var data = response.data;
        data.forEach((element) => {
                var color = allParties.filter(e => e.strana === element.STRANA)[0];
                if (color !== undefined) {
                    partiesNames.push(element.STRANA);
                    partiesVotes.push(element.COUNT);
                    partiesColors.push(color.color);
                }
            }
        );

        repaintChart('myChartKraj');
    }).catch(function (error) {
        console.log(error);
    });
}


function repaintChart(id) {
    const ctx = document.getElementById(id).getContext('2d');
    const myChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: partiesNames,
            datasets: [{
                label: 'Konečné výsledky voleb',
                data: partiesVotes,
                backgroundColor: partiesColors
            }]
        },
        options: {
            maintainAspectRatio: false,
        }
    });
}


window.refreshMap = function() {
    axios.get('http://localhost:5000/krajeNejlepsi').then(function (response) {
        var kraje = response.data;
        allKraje.forEach((kraj) => {
            var mapaKraj = document.getElementById(kraj._id);
            var strana = kraje.filter(e => e._id === kraj._id)[0].strana;
            var color = allParties.filter(e => e.strana === strana)[0].color;
            mapaKraj.style.fill = color;
        });
    }).catch(function (error) {
        console.log(error);
    });
}

