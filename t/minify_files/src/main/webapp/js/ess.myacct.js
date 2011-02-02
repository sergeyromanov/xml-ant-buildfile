ess.myacct = {};

ess.myacct.preferredcc = function(url, message, ccPreferredForm, thisCheckBox){
	var oldPreferredCC = false;
	var newPreferredCC = thisCheckBox;
	$$('.preferredCC').each(function(node){
		if(node.checked && !oldPreferredCC && newPreferredCC.value!=node.value){
			oldPreferredCC = node;
			node.checked = false;
		}
	});
	if (!ess.confirmAction(url, message, ccPreferredForm)){
		newPreferredCC.checked = !newPreferredCC.checked;
		if(oldPreferredCC){
			oldPreferredCC.checked = true;
		}
	} else {
		newPreferredCC.checked = newPreferredCC.checked;
	}
}

ess.myacct.toggleEditLoyalty = function() {
  var edit = $("edit-button");
  var editForm = $("editLoyaltyAccount");
  if (!edit || !editForm) {
    return;
  }
  edit.observe("click", function() {
    $("editLoyaltyAccount").toggleClassName("hide");
    $("edit-wrapper").toggleClassName("hide");
	$('editLoyaltyAccount').accountId.value = $('deleteLoyaltyAccountCommand').accountId.value;
  });
  edit.href = "#editLoyalty";

  //create cancel link
  var cancel = document.createElement("input");
  cancel.type="button";
  cancel.id="cancelButton";
  editForm.select('fieldset')[0].appendChild(cancel);
  cancel = $('cancelButton');
  cancel.addClassName('cancel');
  cancel.value = ess.messages.cancelButton;
  cancel.observe("click", function() {
	$("editLoyaltyAccount").toggleClassName("hide");
	$("edit-wrapper").toggleClassName("hide");
	// remove all errors
	$('editLoyaltyAccount').select('.error').each(function(v){
		if(v.tagName == 'SPAN' || v.tagName == 'P'){
			v.remove();
		}else{
			v.removeClassName('error');
		}
	});
	$('editLoyaltyAccount').select('.fielderror').each(function(v){
	if(v.tagName == 'SPAN'){
		v.removeClassName('fielderror');
	}else{
		v.removeClassName('fielderror');
	}
	});
	$('editLoyaltyAccount').accountId.value = $('deleteLoyaltyAccountCommand').accountId.value;
  });

  // check if required to open at inital state
  if(ess.myacct.errorEditLoyalty){
  $("editLoyaltyAccount").toggleClassName("hide");
    $("edit-wrapper").toggleClassName("hide");
  }
};


document.observe("dom:loaded", function(e) {
	if($("loyalty")){
		ess.myacct.toggleEditLoyalty();
	}
});