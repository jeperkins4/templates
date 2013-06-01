<% if namespaced? -%>
require_dependency "<%= namespaced_file_path %>/application_controller"

<% end -%>
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController
  respond_to :html, :json

  expose(:<%= plural_table_name %>) {  <%= orm_class.all(class_name) %> }
  expose(:<%= singular_table_name %>) { params[:id].present? ? <%= class_name %>.find(params[:id]) : <%= class_name %>.new(params[:<%= singular_table_name %>]) }

  # POST <%= route_url %>
  # POST <%= route_url %>.json
  def create
    respond_to do |format|
      if <%= orm_instance.save %>
        format.html { redirect_to <%= singular_table_name %>, <%= key_value :notice, "'#{human_name} was successfully created.'" %> }
        format.json { render <%= key_value :json, "#{singular_table_name}" %>, <%= key_value :status, ':created' %>, <%= key_value :location, "#{singular_table_name}" %> }
      else
        format.html { render <%= key_value :action, '"new"' %> }
        format.json { render <%= key_value :json, "#{orm_instance.errors}" %>, <%= key_value :status, ':unprocessable_entity' %> }
      end
    end
  end

  # PUT <%= route_url %>/1
  # PUT <%= route_url %>/1.json
  def update
    respond_to do |format|
      if <%= orm_instance.update_attributes("params[:#{singular_table_name}]") %>
        format.html { redirect_to <%= singular_table_name %>, <%= key_value :notice, "'#{human_name} was successfully updated.'" %> }
        format.json { head :no_content }
      else
        format.html { render <%= key_value :action, '"edit"' %> }
        format.json { render <%= key_value :json, "#{orm_instance.errors}" %>, <%= key_value :status, ':unprocessable_entity' %> }
      end
    end
  end

  # DELETE <%= route_url %>/1
  # DELETE <%= route_url %>/1.json
  def destroy
    <%= orm_instance.destroy %>

    respond_to do |format|
      format.html { redirect_to <%= index_helper %>_url }
      format.json { head :no_content }
    end
  end
end
<% end -%>
