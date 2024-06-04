import React from "react";
import cw from "../assets/cw.svg";
import "./style.css";

const Header = () => {
  return (
    <div>
      <div className="text-center">
        <h6 className="text-center mt-5">
          This app has been developed using Terraform, Ansible and Jenkins on AWS.
        </h6>
        <h1 className="text-center mt-5 header-text">Todo List</h1>
      </div>
    </div>
  );
};

export default Header;
