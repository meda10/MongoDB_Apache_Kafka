var partiesNames = [];
var partiesVotes = [];
var partiesColors = [];


window.refreshChart = function() {
    partiesNames = [];
    partiesVotes = [];
    partiesColors = [];


    var parties = [
       {"party" : "strana a", "voices" : 20, 'color' : 'rgb(255, 99, 132)'},
       {"party" : "strana b", "voices" : 12, 'color' : 'rgb(54, 162, 235)'},
       {"party" : "strana c", "voices" : 5, 'color' : 'rgb(153, 102, 255)'},
       {"party" : "strana d", "voices" : 19, 'color' : 'rgb(255, 159, 64)'},
    ];


    parties.forEach((element) => {
            partiesNames.push(element.party);
            partiesVotes.push(element.voices);
            partiesColors.push(element.color);
        }
    );

    const ctx = document.getElementById('myChart').getContext('2d');
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
