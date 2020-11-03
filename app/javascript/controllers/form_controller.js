import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [
    "restaurant",
    "restaurant_input",
    "category",
    "category_name",
    "category_print",
    "category_input",
    "category_wrapper",
    "item_name",
    "item_print",
    "item_input",
    "item_wrapper",
    "item_price",
    "item_description",
  ];

  type_name() {
    this.restaurantTarget.innerText = this.restaurant_inputTarget.value;
  }

  type_category(e) {
    let inputId = e.target.dataset.id;
    let kids = this.category_printTarget.children;

    for (let i = 0; i < kids.length; i++) {
      if (kids[i].dataset.id == inputId) {
        kids[i].innerText = e.target.value;
      }
    }
  }

  type_item(e) {
    let inputId = e.target.dataset.id;
    let kids = this.item_printTarget.children;

    for (let i = 0; i < kids.length; i++) {
      if (kids[i].dataset.id == inputId) {
        kids[i].innerText = e.target.value;
      }
    }
  }

  type_price(e) {
    let inputId = e.target.dataset.idItemPrice;
    let kids = this.item_printTarget.children;

    for (let i = 0; i < kids.length; i++) {
      if (kids[i].dataset.idPrice == inputId) {
        kids[i].innerText = `$${e.target.value}`;
      }
    }
  }

  type_description(e) {
    let inputId = e.target.dataset.idItemDescription;

    let kids = this.item_printTarget.children;
    for (let i = 0; i < kids.length; i++) {
      if (kids[i].dataset.idDescription == inputId) {
        kids[i].innerText = e.target.value;
      }
    }
  }

  // duplicate_category_input() {
  //   let count = this.category_wrapperTarget.childElementCount + 1;
  //   // create new checkmark and input field
  //   this.category_wrapperTarget.insertAdjacentHTML(
  //     "beforeend",
  //     `<label class="inline-flex items-center mt-3" data-id-input="${count}">
  //       <span class="ml-2 text-gray-700">
  //         <input class="shadow appearance-none border rounded w-full py-2 px-4 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" data-id="${count}" type="text" placeholder="..." data-target="form.category_name" data-action="keyup->form#type_category">
  //       </span>
  //       <div class="ml-2 h-5 w-5 cursor-pointer" data-action="click->form#delete_category" data-id="${count}">
  //         <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="#D3D3D3">
  //           <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
  //         </svg>
  //       </div>
  //     </label>`
  //   );
  //   // create new category div on iphone screen
  //   this.category_printTarget.insertAdjacentHTML(
  //     "beforeend",
  //     `<div class="mt-3" data-id="${count}">...</div>`
  //   );
  // }

  duplicate_item_input() {
    let count = this.item_wrapperTarget.childElementCount + 1;

    this.item_wrapperTarget.insertAdjacentHTML(
      "beforeend",
      ` <label class="inline-flex items-center my-3" data-id-input="${count}">
        <span class="w-3/4 ml-2 text-gray-700">
          <input class="shadow appearance-none border rounded w-full py-2 px-4 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" data-id="${count}" type="text" placeholder="Spaghetti" data-target="form.item_name" data-action="keyup->form#type_item">
        </span>
        <div class="w-1/4 ml-2 relative rounded-md shadow-sm">
          <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
            <span class="text-gray-500 sm:text-sm sm:leading-5">$</span>
          </div>
          <input class="shadow appearance-none border rounded w-full py-2 pl-6 pr-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" placeholder="0.00" data-id-item-price="${count}" data-target="form.item_price"data-action="keyup->form#type_price">
        </div>
        <div class="ml-2 h-5 w-5 cursor-pointer" data-action="click->form#delete_item" data-id="${count}">
          <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="#D3D3D3">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </div>
      </label>
      <span class="ml-2 text-gray-700" data-id-desc-input="${count}">
        <input class="shadow appearance-none border rounded w-full py-2 px-4 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" data-id-item-description="${count}" type="text" placeholder="description" data-target="form.item_description" data-action="keyup->form#type_description">
      </span>`
    );

    this.item_printTarget.insertAdjacentHTML(
      "beforeend",
      `<div class="mt-3" data-id="${count}">Spagehtti</div>
      <div class="font-thin text-xs pr-4" data-id-description="${count}">description</div>
      <div class="" data-id-price="${count}">$0.00</div>`
    );
  }

  delete_category(e) {
    let inputId = e.path[1].dataset.id;

    // 1. delete input field category
    let inputKids = this.category_wrapperTarget.children;
    for (let i = 0; i < inputKids.length; i++) {
      if (inputKids[i].dataset.idInput == inputId) {
        inputKids[i].remove();
      }
    }

    // 2.delete category placeholder on iphone screen
    let kids = this.category_printTarget.children;
    for (let i = 0; i < kids.length; i++) {
      if (kids[i].dataset.id == inputId) {
        kids[i].remove();
      }
    }
  }

  delete_item(e) {
    let inputId = e.path[1].dataset.id;
    console.log(inputId);

    // 1. delete input field category
    let inputKids = this.item_wrapperTarget.children;
    for (let i = 0; i < inputKids.length; i++) {
      if (inputKids[i].dataset.idInput == inputId) {
        inputKids[i].remove();
      }
      if (inputKids[i].dataset.idDescInput == inputId) {
        inputKids[i].remove();
      }
    }

    // 2.delete category placeholder on iphone screen
    let kids = this.item_printTarget.children;
    for (let i = 0; i < kids.length; i++) {
      // remove item name
      if (kids[i].dataset.id == inputId) {
        kids[i].remove();
      }
      if (kids[i].dataset.idDescription == inputId) {
        kids[i].remove();
      }
      // remove item price
      if (kids[i].dataset.idPrice == inputId) {
        kids[i].remove();
      }

    }
  }
}
