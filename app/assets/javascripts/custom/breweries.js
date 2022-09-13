const BREWERIES = {};

const createTableRow = (brewery) => {
    const tr = document.createElement("tr");
    tr.classList.add("tablerow");
    const name = tr.appendChild(document.createElement("td"));
    name.innerHTML = brewery.name;
    const year = tr.appendChild(document.createElement("td"));
    year.innerHTML = brewery.year;
    const beerCount = tr.appendChild(document.createElement("td"));
    beerCount.innerHTML = brewery.beer_count;
    const active = tr.appendChild(document.createElement("td"));
    active.innerHTML = brewery.is_active ? 'active' : 'retired';

    return tr;
};

BREWERIES.show = () => {
    document.querySelectorAll(".tablerow").forEach((el) => el.remove());
    const table = document.getElementById("brewery-table");

    BREWERIES.list.forEach((brewery) => {
        const tr = createTableRow(brewery);
        table.appendChild(tr);
    });
};

const handleResponse = (beers) => {
    BREWERIES.list = beers;
    BREWERIES.show();
};


const breweries = () => {
    if (document.querySelectorAll("#brewery-table").length < 1) return;

    fetch("breweries.json")
        .then((response) => response.json())
        .then(handleResponse);
};

export { breweries };