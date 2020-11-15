import ApplicationController from "./application_controller";
// Import UJS so we can access the Rails.ajax method
import Rails from "@rails/ujs";
/* This is the custom StimulusReflex controller for the Example Reflex.
 * Learn more at: https://docs.stimulusreflex.com
 */
export default class extends ApplicationController {
  static targets = [
    "logo_input",
    "logo_output",
    "picture_meal_item",
    "meal_picture_input",
    "links_category",
    "list_tabs",
    "one_tab",
    "list_panels",
    "one_panel",
    "one_category",
    "template_category_field",
    "template_category_print",
    "template_item_print",
    "template_item_field",
    "item_fields_template",
    "categories",
    "items",
    "one_item",
    "template_tab_print",
    "template_panel_print",
    "template_wrapper",
    "delete_icon_meal_picture",
  ];

  connect() {
    super.connect();
    // add your code here, if applicable
    this.load();
  }

  load() {
    const path = window.location.href; // check if page is edit
    if (path.endsWith("edit")) {
      const panels = this.one_panelTargets;
      panels.forEach((panel, index) => {
        const update = panel.innerHTML.replace(/NEW_CATEGORY/g, index);
        panel.innerHTML = update;
      });
      // https://api.rubyonrails.org/v4.0.1/classes/ActiveRecord/NestedAttributes/ClassMethods.html
    }
  }

  // prettier-ignore
  add_category(event) {
    const id = new Date().getTime(); // create random time-stamp as unique category identifier
    // 1. create extra input
    this.add_element(id, this.template_category_printTarget, this.categoriesTarget, "beforeend");
    // 2. print on iphone
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
    const new_category_id = event.target.dataset.category;
    const category_id = event.target.dataset.categoryId;
    const menu_item_id = new Date().getTime();
    console.log(`New Category ID: ${new_category_id}`);
    console.log(`Category ID: ${category_id}`);
    console.log(`Menu item ID: ${menu_item_id}`)

    // get template and insert new random menu id
    const all_fields = this.template_item_fieldTargets;
    let one_field = all_fields.find(template => template.dataset.categoryId === category_id);
    one_field = one_field.innerHTML.replace(/NEW_MENU_ITEM/g, menu_item_id);
    event.target.insertAdjacentHTML("beforebegin", one_field);


    // const all_templates = this.template_wrapperTarget.getElementsByTagName(
    //   "template"
    // );
    // // console.log(all_templates)
    // for (let template of all_templates) {
    //     // console.log(template)
    //   // get correct template which matches new_category_id
    //   if (template.innerHTML.includes(new_category_id)) {
    //     const content = template.innerHTML.replace(
    //       /NEW_MENU_ITEM/g,
    //       menu_item_id
    //     );
    //     event.target.insertAdjacentHTML("beforebegin", content);
    //   }
    // }

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


  get_category_id(existId, event) {
    if (existId) {
      return existId;
    } else {
      const name = event.target.previousElementSibling.name
      return name.match(/\d{5,}/);
    }
  }

  delete_category(event) {
    const existId = event.target.dataset.categoryId
    const category_id = this.get_category_id(existId, event)
    console.log(`category id: ${category_id}`);

    // 1. delete 2-fold (in browser and in DB)
    const wrapper = event.target.closest(".nested-fields"); // look in parent for class
    if (wrapper.dataset.newRecord == "true") {
      // remove field if it's a new record added during session
      wrapper.remove();
    } else {
      // remove field from db by setting hidden-field value to true
      wrapper.querySelector("input[name*='_destroy']").value = 1;
      wrapper.style.display = "none"; //remove visibility from page
    }

    // 2. delete tab element
    const all_tabs = this.one_tabTargets
    let selected_tab = ''
    if (existId) {
      selected_tab = all_tabs.find(tab => tab.dataset.tabId === category_id);
    } else {
      selected_tab = all_tabs.find(tab => tab.id.match(/\d{2,}/)[0] == category_id); //explicit two equal signs
    }
    selected_tab.parentElement.remove();

    // 3. delete panel element
    const all_panels = this.one_panelTargets
    let selected_panel = ''
    if (existId) {
      selected_panel =  all_panels.find(panel => panel.dataset.panelId === category_id);
    } else {
      selected_panel = all_panels.find((panel) => panel.id == category_id); //explicit two equal signs
    }
    selected_panel.remove();

    // 4. delete phone tab
    const all_categories = this.one_categoryTargets
    let selected_category = ''
     if (existId) {
      selected_category = all_categories.find(category => category.dataset.categoryId === category_id);
    } else {
      selected_category = all_categories.find(category => category.id.match(/\d{2,}/)[0]== category_id); //explicit two equal signs
    }
    selected_category.remove();

    // 5. delete phone item element
    // TO BE COMPLETED !!!!!
    const all_items = this.one_itemTargets;
    all_items.forEach(item =>
    {
      if (item.dataset.categoryId === category_id) {
        item.remove()
      }
    });
  }

  preview_logo() {
    const input = this.logo_inputTarget;
    const logos = this.logo_outputTargets;
    const form_logo = logos[0];
    const phone_logo = logos[1]

    if (input.files && input.files[0]) {
      const reader = new FileReader();

      reader.onload = function () {
        logos.forEach((logo) => {
          logo.src = reader.result; //set src attribute on target img html element
        });
        phone_logo.classList.remove("hidden")
        input.parentElement.classList.add("hidden");
        form_logo.parentElement.classList.remove("hidden");
        form_logo.parentElement.classList.add("flex"); // because flex and hidden are both properties of display
      };

      reader.readAsDataURL(input.files[0]);
      console.log(input.files);
    }
  }

  extract_menu_item_id(element) {
    if (element.target.dataset.pictureId) {
      return event.target.dataset.pictureId;
    } else {
      const extracted_id = element.target.name.match(/items_attributes\S\S\d{5,}/);
      return extracted_id[0].split("[").pop();
    }
  }


  preview_meal_picture(event) {
    const menu_item_id = this.extract_menu_item_id(event);
    console.log(`Menu Item ID: ${menu_item_id}`)
    const input = event.target;

    const pics = this.picture_meal_itemTargets;
    console.log(pics)
    const meal_pics = pics.filter(pic => {
      console.log(pic.dataset)
      if (pic.dataset.pictureId) {
        return pic.dataset.pictureId == menu_item_id;
      } else {
        console.log("pic name");
        console.log(pic);
        let extracted_id = pic.name.match(/items_attributes\S\S\d{5,}/);
        extracted_id = extracted_id[0].split("[").pop();
        extracted_id == menu_item_id;
      }
    });
    console.log(meal_pics)

    if (input.files && input.files[0]) {
      let reader = new FileReader();

      reader.onload = function () {
        meal_pics.forEach((pic) => {
          pic.src = reader.result; //set src attribute on target img html element
        });
        input.parentElement.classList.add("hidden");
        meal_pics[0].parentElement.classList.remove("hidden");
        meal_pics[0].parentElement.classList.add("flex");
        meal_pics[1].parentElement.classList.remove("hidden"); // show meal pic on phone if hidden

        input.src = reader.result;
      };

      reader.readAsDataURL(input.files[0]);

      input.parentElement.nextElementSibling.classList.add("hidden"); // hide delete icon too
    }
  }

  delete_logo() {
    const logos = this.logo_outputTargets;
    const form_logo = logos[0].parentElement; // singular, first hit on page - form
    form_logo.classList.remove("flex");
    form_logo.classList.add("hidden");

    const phone_logo = logos[1];
    phone_logo.classList.add("hidden")
    // phone_logo.src = "../../assets/icons/photo.svg"; // set to original picture icon

    const input = this.logo_inputTarget;
    console.log(input.files)
    input.value = ''
    console.log(input.files)
    input.parentElement.classList.remove("hidden");
  }

  delete_item_picture(event) {
    const menu_item_id = this.extract_menu_item_id(event);
    console.log(`DELETE_ITEM_PICTURE --> menu item id: ${menu_item_id}`)

    const pics = this.picture_meal_itemTargets;
    console.log(pics)
    const meal_pics = pics.filter(
      (pic) => pic.dataset.pictureId === menu_item_id
    );

    meal_pics[0].parentElement.classList.add("hidden"); // hide custom pic

    const inputs = this.meal_picture_inputTargets; // add standard pic again
    const input_picture = inputs.find(pic => {
      if (pic.dataset.pictureId) {
        return pic.dataset.pictureId == menu_item_id;
      } else {
        let extracted_id = pic.name.match(/items_attributes\S\S\d{5,}/);
        extracted_id = extracted_id[0].split("[").pop();
        return extracted_id == menu_item_id;
      }
    }
    );
    console.log(input_picture)
    input_picture.removeAttribute("src");
    console.log(input_picture)
    input_picture.parentElement.classList.remove("hidden");

    // hide the meal pic on phone when deleted
    meal_pics[1].classList.add("hidden");
    this.deletePicture(menu_item_id)
  }

  deletePicture(id) {
    console.log|("indeside")
    console.log(window.location.host);
    Rails.ajax({
      type: "post",
      url: window.location.origin + "/purge_item_picture",
      data: id,
    });
  }

}

