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
    "template_wrapper"
  ];

  connect() {
    super.connect();
    // add your code here, if applicable
  }

  add_category(event) {
    const id = new Date().getTime(); // create random time-stamp as unique category identifier
    // 1. create extra input
    this.add_element(id, this.template_category_printTarget, this.categoriesTarget, "beforeend");
    //2. print on iphone
    this.add_element(id, this.template_category_fieldTarget, this.links_categoryTarget, "beforebegin");
    // 3. print on tab nav
    this.add_element(id, this.template_tab_printTarget, this.list_tabsTarget, "beforeend");
    // 4. print tab panel
    this.add_element(id, this.template_panel_printTarget, this.list_panelsTarget, "beforeend");
  }

  add_element(id, input, output, position) {
    const content = input.innerHTML.replace(/NEW_CATEGORY/g, id);
    output.insertAdjacentHTML(position, content);
  }


  add_item(event) {
    const category_id = event.target.dataset.category
    const menu_item_id = new Date().getTime();
    // console.log(`Category ID: ${category_id}`)
    // console.log(`Menu item ID: ${menu_item_id}`)

    let all_templates = this.template_wrapperTarget.getElementsByTagName("template");
    for (let template of all_templates) {
      // get correct template which matches category_id
      if (template.innerHTML.includes(category_id)) {
        const content = template.innerHTML.replace(/NEW_MENU_ITEM/g,menu_item_id);
        event.target.insertAdjacentHTML("beforebegin", content);
      }
    }

     const print_content = this.template_item_printTarget.innerHTML.replace(
       /NEW_MENU_ITEM/g,
       menu_item_id
     );
     this.itemsTarget.insertAdjacentHTML("beforeend", print_content);
  }



  delete_category(event) {
    this.delete_element(this.categoriesTarget, event, "category");
  }

  delete_item(event) {
    this.delete_element(this.itemsTarget, event, "item");
  }

  delete_element(target, event, id_selector) {
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

     // 2. delete printed element
    let input_element = wrapper.querySelector("input");
    let extracted_id = input_element.name.replace(/\D/g, "");
    let print_element = target.querySelector(
      `#${id_selector}-${extracted_id}`
    );
    print_element.remove();
  }

  preview_logo() {
    const input = this.logo_inputTarget;
    const output = this.logo_outputTarget;

    if (input.files && input.files[0]) {
      const reader = new FileReader();

      reader.onload = function () {
        output.src = reader.result;
      };

      reader.readAsDataURL(input.files[0]);
    }
  }

  preview_meal_picture(event) {
    let extracted_id = event.target.name.replace(/\D/g, "");
    let input = event.target;

    let output = this.itemsTarget;
    let img_element = output.querySelector(`#item-picture-${extracted_id}`);

    if (input.files && input.files[0]) {
      let reader = new FileReader();

      reader.onload = function () {
        img_element.src = reader.result;
      };

      reader.readAsDataURL(input.files[0]);
    }
  }
}
