const page1 = document.getElementById("div1");
const page2 = document.getElementById("div2");
const page3 = document.getElementById("div3");

function scrollToPage(page) {
    setTimeout(() => {
        page.scrollIntoView({ behavior: 'smooth'});
        switch (page.id) {
            case 'div1':
                scrollToPage(page2);
                break;

            case 'div2':
                scrollToPage(page3);
                break;

            case 'div3':
                scrollToPage(page1);
                break;
        }
    }, 10000);
}

scrollToPage(page2);