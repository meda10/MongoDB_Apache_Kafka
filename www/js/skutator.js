const axios = require('axios');
var autocomplete = require('autocompleter');

const form = document.getElementById('form_hlasy');
form.addEventListener('submit', handleSubmit);

// const form2 = document.getElementById('form_pocet_volicu_v_kraji');
// strana.addEventListener('input', handleInput);

let lidi = []
let strany = []
let kraje = []
let select_values = []

function removeOptions(selectElement) {
    var i, L = selectElement.options.length - 1;
    for(i = L; i >= 0; i--) {
        selectElement.remove(i);
    }
}

function addOptions(selectElement) {
    for (let i = 0; i < select_values.length; i++) {
        let select = document.getElementById(selectElement);
        let option = document.createElement("option");
        option.text = select_values[i].label;
        option.value = select_values[i].value;
        select.add(option);
    }
}

axios.get('http://localhost:5000/lidi', {}).then(function (response) {
    lidiRes = response.data;
    lidiRes.forEach(function(item){
        let obj = { label : item.name, value: item.id, strana: item.strana }
        lidi.push(obj);
    });
    get_lidi()
}).catch(function (error) {
    console.log(error);
});

axios.get('http://localhost:5000/strany', {}).then(function (response) {
    stranyRes = response.data;
    stranyRes.forEach(function(item){
        let obj = { label : item.strana, value: item.strana }
        strany.push(obj);
    });
    get_strany()
}).catch(function (error) {
    console.log(error);
});


axios.get('http://localhost:5000/kraje', {}).then(function (response) {
    krajeRes = response.data;
    krajeRes.forEach(function(item){
        let obj = { label : item.nazev, value: item._id }
        kraje.push(obj);

    });
    get_kraje()
}).catch(function (error) {
    console.log(error);
});

function get_kraje(){
    var input = document.getElementById("kraj");

    autocomplete({
        input: input,
        fetch: function(text, update) {
            text = text.toLowerCase();
            var suggestions = kraje.filter(n => n.label.toLowerCase().startsWith(text))
            update(suggestions);
        },
        onSelect: function(item) {
            input.value = item.label;

        },
    });

    let input2 = document.getElementById("krajname");

    autocomplete({
        input: input2,
        fetch: function(text, update) {
            text = text.toLowerCase();
            var suggestions = kraje.filter(n => n.label.toLowerCase().startsWith(text))
            update(suggestions);
        },
        onSelect: function(item) {
            input2.value = item.label;

        },
    });
}

function get_strany(){
    var input = document.getElementById("strana");
    autocomplete({
        input: input,
        fetch: function(text, update) {
            text = text.toLowerCase();
            var suggestions = strany.filter(n => n.label.toLowerCase().startsWith(text))
            update(suggestions);
        },
        onSelect: function(item) {
            input.value = item.label;
            select_values = []
            lidi.forEach(function(it){
                if(it.strana === item.label) {
                    let obj = {label: it.label, value: it.value}
                    select_values.push(obj);
                }
            });
            removeOptions(document.getElementById('select_pref1'));
            removeOptions(document.getElementById('select_pref2'));
            removeOptions(document.getElementById('select_pref3'));
            removeOptions(document.getElementById('select_pref4'));
            addOptions('select_pref1')
            addOptions('select_pref2')
            addOptions('select_pref3')
            addOptions('select_pref4')
        },
    });
}

function get_lidi(){
    var select_pref1 = document.getElementById("select_pref1");
    var select_pref2 = document.getElementById("select_pref2");
    var select_pref3 = document.getElementById("select_pref3");
    var select_pref4 = document.getElementById("select_pref4");
    autocomplete({
        input: select_pref1,
        fetch: function(text, update) {
            text = text.toLowerCase();
            var suggestions = lidi.filter(n => n.label.toLowerCase().startsWith(text))
            update(suggestions);
        },
        onSelect: function(item) {
            select_pref1.value = item.label;
        },
    });
    autocomplete({
        input: select_pref2,
        fetch: function(text, update) {
            text = text.toLowerCase();
            var suggestions = lidi.filter(n => n.label.toLowerCase().startsWith(text))
            update(suggestions);
        },
        onSelect: function(item) {
            select_pref2.value = item.label;
        },
    });
    autocomplete({
        input: select_pref3,
        fetch: function(text, update) {
            text = text.toLowerCase();
            var suggestions = lidi.filter(n => n.label.toLowerCase().startsWith(text))
            update(suggestions);
        },
        onSelect: function(item) {
            select_pref3.value = item.label;
        },
    });
    autocomplete({
        input: select_pref4,
        fetch: function(text, update) {
            text = text.toLowerCase();
            var suggestions = lidi.filter(n => n.label.toLowerCase().startsWith(text))
            update(suggestions);
        },
        onSelect: function(item) {
            select_pref4.value = item.value;
        },
    });
}

function handleSubmit(event) {
    event.preventDefault();
    const data = new FormData(event.target);
    const value = Object.fromEntries(data.entries());
    console.log({ value });

    let kraj_id = null
    let strana = value.strana
    kraje.forEach(function(item){
        if(value.kraj === item.label){
            kraj_id = item.value
        }
    });

    // const post_data = JSON.stringify({"records": [{"value": {"id_kraje": kraj_id, "strana": strana, "preferencni": [pref1, pref2, pref3, pref4]}}]});
    const post_data = JSON.stringify({"records": [{"value": {"id_kraje": kraj_id, "strana": strana, "preferencni": [value.pref1, value.pref2, value.pref3, value.pref4]}}]});
    axios.post('http://localhost:8082/topics/hlasy', post_data, {
        headers: { 'Content-Type': 'application/vnd.kafka.json.v2+json' }
    }).then(function (response) {
        console.log(response);
        alert("Data úspěšně odeslána");
        location.reload();
        form.reset()
        form2.reset()
    }).catch(function (error) {
        console.log(error);
    });
}


const form2 = document.getElementById('form_pocet_volicu_v_kraji');
form2.addEventListener('submit', handleSubmit2);

function handleSubmit2(event) {
    event.preventDefault();
    const data = new FormData(event.target);
    const value = Object.fromEntries(data.entries());
    let kraj_id = null;
    let pocetVolicu = value.pocetvolicu;

    console.log({ value });


    kraje.forEach(function(item){
        if(value.kraj === item.label){
            kraj_id = item.value
        }
    });

    axios.get('http://localhost:5000/pocetVolicu/' +  pocetVolicu + '/kraj/' + kraj_id, {}).then(function (response) {
        console.log(response);
        alert("Data úspěšně odeslána");
        location.reload()
        form.reset()
        form2.reset()
    }).catch(function (error) {
        console.log(error);
    });
}

