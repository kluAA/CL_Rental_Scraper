document.addEventListener("DOMContentLoaded", e => {
    const input = document.getElementById("city-input");
    const button = document.getElementById("grab-link");
    const linkLocation = document.getElementById("link");
    const message = document.getElementById("message");
    button.addEventListener('click', e => {
        e.preventDefault();
        message.innerText = "Download: Generating link...";
        linkLocation.innerHTML = "";
        grabCSV(input.value)
            .then(csv => {
                const link = document.createElement("a");
                const encoded = encodeURI(csv);
                const date = new Date().toISOString().substring(0,10);
                message.innerText = "Download: ";
                link.setAttribute("href", 'data:text/csv;charset=UTF-8,' + encoded);
                link.setAttribute("download", `${date}_${input.value}_3_bedroom_2_bathroom.csv`);
                link.text = `${date}_${input.value}_3_bedroom_2_bathroom.csv`;
                linkLocation.append(link);
            }, err => {
                message.innerText = "Download: ";
                let errorMsg = document.createElement("span");
                errorMsg.setAttribute("id", "error");
                errorMsg.innerText = `${err.responseText}`;
                linkLocation.append(errorMsg);
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