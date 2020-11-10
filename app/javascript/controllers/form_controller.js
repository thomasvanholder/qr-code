import ApplicationController from "./application_controller";
/* This is the custom StimulusReflex controller for the Example Reflex.
 * Learn more at: https://docs.stimulusreflex.com
 */
export default class extends ApplicationController {
  static targets = [
    "logo_input",
    "logo_output",
    "meal_picture_input",
    "meal_picture_output",
    "links_category",
    "list_tabs",
    "list_panels",
    "template_category_field",
    "template_category_print",
    "template_item_print",
    "categories",
    "items",
    "template_tab_print",
    "template_panel_print",
    "template_wrapper",
  ];

  connect() {
    super.connect();
    // add your code here, if applicable
  }

  add_category(event) {
    const id = new Date().getTime(); // create random time-stamp as unique category identifier
    // 1. create extra input
    this.add_element(
      id,
      this.template_category_printTarget,
      this.categoriesTarget,
      "beforeend"
    );
    //2. print on iphone
    this.add_element(
      id,
      this.template_category_fieldTarget,
      this.links_categoryTarget,
      "beforebegin"
    );
    // 3. print on tab nav
    this.add_element(
      id,
      this.template_tab_printTarget,
      this.list_tabsTarget,
      "beforeend"
    );
    // 4. print tab panel
    this.add_element(
      id,
      this.template_panel_printTarget,
      this.list_panelsTarget,
      "beforeend"
    );
  }

  add_element(id, input, output, position) {
    const content = input.innerHTML.replace(/NEW_CATEGORY/g, id);
    output.insertAdjacentHTML(position, content);
  }

  add_item(event) {
    const category_id = event.target.dataset.category;
    const menu_item_id = new Date().getTime();
    // console.log(`Category ID: ${category_id}`)
    // console.log(`Menu item ID: ${menu_item_id}`)

    let all_templates = this.template_wrapperTarget.getElementsByTagName(
      "template"
    );
    for (let template of all_templates) {
      // get correct template which matches category_id
      if (template.innerHTML.includes(category_id)) {
        const content = template.innerHTML.replace(
          /NEW_MENU_ITEM/g,
          menu_item_id
        );
        event.target.insertAdjacentHTML("beforebegin", content);
      }
    }

    const print_content = this.template_item_printTarget.innerHTML.replace(
      /NEW_MENU_ITEM/g,
      menu_item_id
    );
    this.itemsTarget.insertAdjacentHTML("beforeend", print_content);
  }

  delete_item(event) {
    let wrapper = event.target.closest(".nested-fields"); // look in parent for class
    if (wrapper.dataset.newRecord == "true") {
      // remove field if it's a new record added during session
      wrapper.remove();
    } else {
      // remove field from db by setting hidden-field value to true
      wrapper.querySelector("input[name*='_destroy']").value = 1;
      wrapper.style.display = "none"; //remove visibility from page
    }

    // 3. delete printed element
    let input_element = wrapper.querySelector("input");
    let regex_id = this.extract_menu_item_id(input_element);
    let print_element = this.itemsTarget.querySelector(`#item-${regex_id}`);
    print_element.remove();
  }

  extract_menu_item_id(element) {
    let extracted_id = element.name.match(
      /[i][t][e][m][s].[a-z]{3,}\S\S\d{5,}/
    );
    return extracted_id[0].split("[").pop();
  }

  delete_category(event) {
    // 1. delete 2-fold (in browser and in DB)
    let wrapper = event.target.closest(".nested-fields"); // look in parent for class
    if (wrapper.dataset.newRecord == "true") {
      // remove field if it's a new record added during session
      wrapper.remove();
    } else {
      // remove field from db by setting hidden-field value to true
      wrapper.querySelector("input[name*='_destroy']").value = 1;
      wrapper.style.display = "none"; //remove visibility from page
    }

    // 2a. delete nav element
    let element_id = wrapper.querySelector("input[name*='_destroy']");
    let regex_id = element_id.name.match(/\d{5,}/)[0];
    console.log(regex_id);

    let all_tabs = this.list_tabsTarget.getElementsByTagName("li");
    for (let tab of all_tabs) {
      if (tab.innerHTML.includes(regex_id)) {
        // match extracted_id
        tab.remove();
      }
    }
    // 2b. delete panel element
    let one_panel = this.list_panelsTarget.querySelector(`#link-${regex_id}`);
    let panel_div = one_panel.parentElement;
    panel_div.remove();

    // 3. delete printed element
    let input_element = wrapper.querySelector("input");
    let extracted_id = input_element.name.replace(/\D/g, "");
    let print_element = this.categoriesTarget.querySelector(
      `#category-${extracted_id}`
    );
    print_element.remove();
  }

  preview_logo() {
    const input = this.logo_inputTarget;
    const logos = this.logo_outputTargets;
    const form_logo = logos[0]

    if (input.files && input.files[0]) {
      const reader = new FileReader();

      reader.onload = function () {
        logos.forEach((logo) => {
          logo.src = reader.result; //set src attribute on target img html element
          input.parentElement.classList.add("hidden");
          form_logo.parentElement.classList.remove("hidden")
          form_logo.parentElement.classList.add("flex") // because flex and hidden are both properties of display
        });
      };

      reader.readAsDataURL(input.files[0]);
    }
  }

  delete_logo() {
    const logos = this.logo_outputTargets;
    const form_logo = logos[0].parentElement; // singular, first hit on page - form
    form_logo.classList.remove("flex");
    form_logo.classList.add("hidden");

    const phone_logo = logos[1];
    phone_logo.src = "../../assets/icons/photo.svg" // set to original picture icon

    const input = this.logo_inputTarget;
    input.parentElement.classList.remove("hidden");
  }

  preview_meal_picture(event) {
    let regex_id = this.extract_menu_item_id(event.target);
    let input = event.target;
    let output = this.itemsTarget;
    let img_element = output.querySelector(`#item-picture-${regex_id}`);

    if (input.files && input.files[0]) {
      let reader = new FileReader();

      reader.onload = function () {
        img_element.src = reader.result;
      };

      reader.readAsDataURL(input.files[0]);
    }
  }
}
