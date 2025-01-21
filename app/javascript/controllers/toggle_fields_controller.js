import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "discountType",
    "discountValue",
    "hiddenDiscountPrice",
    "hiddenPercentage",
  ];

  connect() {
    this.toggleFields(); // Initialize fields on page load
  }

  toggleFields() {
    const discountType = this.discountTypeTarget.value;
    const discountValueField = this.discountValueTarget;

    // Reset the max attribute
    discountValueField.removeAttribute("max");

    if (discountType === "Percentage Reduction") {
      discountValueField.setAttribute("max", "100");
    }

    // Enable the discountValue field
    discountValueField.disabled = false;

    // Clear the hidden fields
    this.hiddenDiscountPriceTarget.value = "";
    this.hiddenPercentageTarget.value = "";
  }
}
