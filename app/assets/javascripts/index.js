document.addEventListener("DOMContentLoaded", e => {
    const root = document.getElementById("root");
    const input = document.getElementById("city-input");
    const button = document.getElementById("grab-link");
    const linkLocation = document.getElementById("link");
    button.addEventListener('click', e => {
        e.preventDefault();
        grabCSV(input.value)
            .then(csv => {
                const link = document.createElement("a");
                const encoded = encodeURI(csv);
                const date = new Date().toISOString().substring(0,10);
                console.log(encoded)
                link.setAttribute("href", 'data:text/csv;charset=UTF-8,' + encoded);
                link.setAttribute("download", `${date}_${input.value}_3_bedroom_2_bathroom.csv`);
                link.text = "test";
                linkLocation.append(link);
                
            })
    })

    function grabCSV(city) {
        return $.ajax({
            method: "GET",
            url: "/api/scraper",
            data: { scraper: { city: city}}
        })
    }
})