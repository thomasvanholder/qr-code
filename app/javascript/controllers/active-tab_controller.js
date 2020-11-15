import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [
    "nav",
    "section",
    "hide_phone",
    "items_content"
  ];

  connect() {
    // console.log("Hello, Stimulus!", this.element);
  }

  isInViewport(el) {
    // set rect to iphone boudingRect
    console.log("section rect")
    const rect = el.getBoundingClientRect();
    console.log(rect)
    console.log("phone_content rect")
    const content = this.items_contentTarget.getBoundingClientRect()
    console.log(content)
    return (
        rect.top >= 0 &&
        rect.left >= 0 &&
        rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) &&
        rect.right <= (window.innerWidth || document.documentElement.clientWidth)
    );
  }

  highlight_nav() {
    this.sectionTargets.forEach((section) => {
      let result = this.isInViewport(section)

      if (result) {
        this.navTargets.forEach((nav) => {
          if (nav.dataset.category == section.dataset.category) {
            nav.classList.add("active-tab");
          } else {
            nav.classList.remove("active-tab");
          }
        })
      }
    })
  }
}

