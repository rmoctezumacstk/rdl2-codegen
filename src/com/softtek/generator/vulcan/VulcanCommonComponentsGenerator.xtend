package com.softtek.generator.vulcan

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.System
import com.softtek.rdl2.ModuleRef
import com.softtek.rdl2.PageContainer

class VulcanCommonComponentsGenerator {
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		fsa.generateFile("vulcan/lib/components/common/Header.jsx", genHeaderJsx(resource, fsa))
		fsa.generateFile("vulcan/lib/components/common/Layout.jsx", genLayoutJsx(resource, fsa))
		fsa.generateFile("vulcan/lib/components/common/SideNavigation.jsx", genSideNavigationJsx(resource, fsa))
		fsa.generateFile("vulcan/lib/components/common/Login.jsx", genLoginJsx(resource, fsa))
	}
	
	def CharSequence genHeaderJsx(Resource resource, IFileSystemAccess2 access2) '''
		import React from "react";
		import { browserHistory } from "react-router";
		import PropTypes from "prop-types";
		import {
		  AppBar,
		  Toolbar,
		  IconButton,
		  Typography,
		  Button,
		  Menu,
		  MenuItem
		} from "@material-ui/core";
		import MenuIcon from "mdi-material-ui/Menu";
		import AccountCircle from "mdi-material-ui/AccountCircle";
		import ChevronLeftIcon from "mdi-material-ui/ChevronLeft";
		import withStyles from "@material-ui/core/styles/withStyles";
		import {
		  getSetting,
		  Components,
		  registerComponent,
		  withCurrentUser
		} from "meteor/vulcan:core";
		import classNames from "classnames";
		
		const drawerWidth = 240;
		const topBarHeight = 60;
		
		const styles = theme => ({
		  appBar: {
		    position: "absolute",
		    transition: theme.transitions.create(["margin", "width"], {
		      easing: theme.transitions.easing.sharp,
		      duration: theme.transitions.duration.leavingScreen
		    })
		  },
		  appBarShift: {
		    marginLeft: drawerWidth,
		    width: `calc(100% - ${drawerWidth}px)`,
		    transition: theme.transitions.create(["margin", "width"], {
		      easing: theme.transitions.easing.easeOut,
		      duration: theme.transitions.duration.enteringScreen
		    })
		  },
		  toolbar: {
		    height: `${topBarHeight}px`,
		    minHeight: `${topBarHeight}px`
		  },
		  headerMid: {
		    flexGrow: 1,
		    display: "flex",
		    alignItems: "center",
		    "& h1": {
		      margin: "0 24px 0 0",
		      fontSize: "18px",
		      lineHeight: 1
		    }
		  },
		  menuButton: {
		    marginRight: theme.spacing.unit * 3
		  }
		});
		
		const NavLoggedIn = ({ currentUser }) => (
		  <Button
		    color="inherit"
		    onClick={() => {
		      Meteor.logout(() => browserHistory.push("/"));
		    }}
		  >
		    Logout
		  </Button>
		);
		
		const NavLoggedOut = ({ currentUser }) => (
		  <Button
		    color="inherit"
		    onClick={() => {
		      browserHistory.push("/login");
		    }}
		  >
		    Login
		  </Button>
		);
		
		const Header = (props, context) => {
		  const { classes, currentUser } = props;
		  const isSideNavOpen = props.isSideNavOpen;
		  const toggleSideNav = props.toggleSideNav;
		
		  const siteTitle = getSetting("title", "My App");
		
		  return (
		    <AppBar
		      className={classNames(
		        classes.appBar,
		        isSideNavOpen && classes.appBarShift
		      )}
		    >
		      <Toolbar className={classes.toolbar}>
		        <IconButton
		          aria-label="open drawer"
		          onClick={e => toggleSideNav()}
		          className={classNames(classes.menuButton)}
		          color="inherit"
		        >
		          {isSideNavOpen ? <ChevronLeftIcon /> : <MenuIcon />}
		        </IconButton>
		
		        <div className={classNames(classes.headerMid)}>
		          <Typography variant="h6" color="inherit" className="tagline">
		            {siteTitle}
		          </Typography>
		        </div>
		
		        {currentUser ? (
		          <NavLoggedIn currentUser={currentUser} />
		        ) : (
		          <NavLoggedOut currentUser={currentUser} />
		        )}
		      </Toolbar>
		    </AppBar>
		  );
		};
		
		Header.propTypes = {
		  classes: PropTypes.object.isRequired,
		  isSideNavOpen: PropTypes.bool,
		  toggleSideNav: PropTypes.func
		};
		
		Header.displayName = "Header";
		
		registerComponent({
		  name: "Header",
		  component: Header,
		  hocs: [withCurrentUser, [withStyles, styles]]
		});
	'''
	
	def CharSequence genLayoutJsx(Resource resource, IFileSystemAccess2 access2) '''
		import React from "react";
		import PropTypes from "prop-types";
		import Drawer from "@material-ui/core/Drawer";
		import AppBar from "@material-ui/core/AppBar";
		import Toolbar from "@material-ui/core/Toolbar";
		import { Components, replaceComponent, Utils } from "meteor/vulcan:core";
		import withStyles from "@material-ui/core/styles/withStyles";
		import classNames from "classnames";
		
		const drawerWidth = 240;
		const topBarHeight = 60;
		
		const styles = theme => ({
		  "@global": {
		    html: {
		      background: theme.palette.background.default,
		      WebkitFontSmoothing: "antialiased",
		      MozOsxFontSmoothing: "grayscale",
		      overflow: "hidden"
		    },
		    body: {
		      margin: 0
		    }
		  },
		  root: {
		    width: "100%",
		    zIndex: 1,
		    overflow: "hidden"
		  },
		  appFrame: {
		    position: "relative",
		    display: "flex",
		    height: "100vh",
		    alignItems: "stretch"
		  },
		  drawerPaper: {
		    position: "relative",
		    width: drawerWidth,
		    backgroundColor: theme.palette.background[200]
		  },
		  drawerHeader: {
		    height: `${topBarHeight}px !important`,
		    minHeight: `${topBarHeight}px !important`,
		    position: "relative !important"
		  },
		  content: {
		    padding: theme.spacing.unit * 4,
		    width: "100%",
		    marginLeft: -drawerWidth,
		    flexGrow: 1,
		    backgroundColor: theme.palette.background.default,
		    color: theme.palette.text.primary,
		    transition: theme.transitions.create("margin", {
		      easing: theme.transitions.easing.sharp,
		      duration: theme.transitions.duration.leavingScreen
		    }),
		    height: `calc(100% - ${topBarHeight}px)`,
		    marginTop: topBarHeight,
		    overflowY: "scroll"
		  },
		  mainShift: {
		    marginLeft: 0,
		    transition: theme.transitions.create("margin", {
		      easing: theme.transitions.easing.easeOut,
		      duration: theme.transitions.duration.enteringScreen
		    })
		  }
		});
		
		class Layout extends React.Component {
		  state = {
		    isOpen: { sideNav: true }
		  };
		
		  toggle = (item, openOrClose) => {
		    const newState = { isOpen: {} };
		    newState.isOpen[item] =
		      typeof openOrClose === "string"
		        ? openOrClose === "open"
		        : !this.state.isOpen[item];
		    this.setState(newState);
		  };
		
		  render = () => {
		    const routeName = Utils.slugify(this.props.currentRoute.name);
		    const classes = this.props.classes;
		    const isOpen = this.state.isOpen;
		
		    return (
		      <div
		        className={classNames(classes.root, "wrapper", `wrapper-${routeName}`)}
		      >
		        <div className={classes.appFrame}>
		          <Components.Header
		            isSideNavOpen={isOpen.sideNav}
		            toggleSideNav={openOrClose => this.toggle("sideNav", openOrClose)}
		          />
		
		          <Drawer
		            variant="persistent"
		            classes={{ paper: classes.drawerPaper }}
		            open={isOpen.sideNav}
		          >
		            <AppBar
		              className={classes.drawerHeader}
		              elevation={4}
		              square={true}
		            >
		              <Toolbar />
		            </AppBar>
		            <Components.SideNavigation />
		          </Drawer>
		
		          <main
		            className={classNames(
		              classes.content,
		              isOpen.sideNav && classes.mainShift
		            )}
		          >
		            {this.props.children}
		          </main>
		
		          <Components.FlashMessages />
		        </div>
		      </div>
		    );
		  };
		}
		
		Layout.propTypes = {
		  classes: PropTypes.object.isRequired,
		  children: PropTypes.node
		};
		
		Layout.displayName = "Layout";
		
		replaceComponent("Layout", Layout, [withStyles, styles]);
	'''
	
	def CharSequence genSideNavigationJsx(Resource resource, IFileSystemAccess2 access2) '''
		import React from "react";
		import PropTypes from "prop-types";
		import {
		  Components,
		  registerComponent,
		  withCurrentUser
		} from "meteor/vulcan:core";
		import { browserHistory } from "react-router";
		import List from "@material-ui/core/List";
		import ListItem from "@material-ui/core/ListItem";
		import ListItemIcon from "@material-ui/core/ListItemIcon";
		import ListItemText from "@material-ui/core/ListItemText";
		import Divider from "@material-ui/core/Divider";
		import Collapse from "@material-ui/core/Collapse";
		import ExpandLessIcon from "mdi-material-ui/ChevronUp";
		import ExpandMoreIcon from "mdi-material-ui/ChevronDown";
		import LockIcon from "mdi-material-ui/Lock";
		import UsersIcon from "mdi-material-ui/AccountMultiple";
		import ThemeIcon from "mdi-material-ui/Palette";
		import HomeIcon from "mdi-material-ui/Home";
		import VectorSquare from "mdi-material-ui/VectorSquare";
		import withStyles from "@material-ui/core/styles/withStyles";
		import Users from "meteor/vulcan:users";
		
		const styles = theme => ({
		  root: {},
		  nested: {
		    paddingLeft: theme.spacing.unit * 4
		  }
		});
		
		class SideNavigation extends React.Component {
		  state = {
		    isOpen: { admin: false }
		  };
		
		  toggle = item => {
		    const newState = { isOpen: {} };
		    newState.isOpen[item] = !this.state.isOpen[item];
		    this.setState(newState);
		  };
		
		  render() {
		    const currentUser = this.props.currentUser;
		    const classes = this.props.classes;
		    const isOpen = this.state.isOpen;
		
		    return (
		      <div className={classes.root}>
		        <List>
		          <ListItem button onClick={() => { browserHistory.push("/"); }}>
		            <ListItemIcon>
		              <HomeIcon />
		            </ListItemIcon>
		            <ListItemText inset primary="Home" />
		          </ListItem>
		          «FOR System s : resource.allContents.toIterable.filter(typeof(System))»
		          	«FOR m : s.modules_ref»
		          		«IF m.countPageLanmarks > 0»
		          			«FOR page : m.module_ref.elements.filter(typeof(PageContainer))»
		          			«IF page.landmark!==null && page.landmark.trim.equals("true")»
		          			<ListItem button onClick={() => { browserHistory.push('/«page.name.toLowerCase»'); }}>
		          			  <ListItemIcon>
		          			  	<VectorSquare/>
		          			  </ListItemIcon>
		          			  <ListItemText inset primary="«page.page_title»"/>
		          			</ListItem>
		          			«ENDIF»
		          			«ENDFOR»
		          		«ENDIF»
		          	«ENDFOR»
		          «ENDFOR»
		        </List>
		
		        {Users.isAdmin(currentUser) && (
		          <div>
		            <Divider />
		            <List>
		              <ListItem button onClick={e => this.toggle("admin")}>
		                <ListItemIcon>
		                  <LockIcon />
		                </ListItemIcon>
		                <ListItemText primary="Admin" />
		                {isOpen.admin ? <ExpandLessIcon /> : <ExpandMoreIcon />}
		              </ListItem>
		              <Collapse
		                in={isOpen.admin}
		                transitionduration="auto"
		                unmountOnExit
		              >
		                <ListItem
		                  button
		                  className={classes.nested}
		                  onClick={() => {
		                    browserHistory.push("/admin");
		                  }}
		                >
		                  <ListItemIcon>
		                    <UsersIcon />
		                  </ListItemIcon>
		                  <ListItemText inset primary="Users" />
		                </ListItem>
		                <ListItem
		                  button
		                  className={classes.nested}
		                  onClick={() => {
		                    browserHistory.push("/theme");
		                  }}
		                >
		                  <ListItemIcon>
		                    <ThemeIcon />
		                  </ListItemIcon>
		                  <ListItemText inset primary="Theme" />
		                </ListItem>
		              </Collapse>
		            </List>
		          </div>
		        )}
		      </div>
		    );
		  }
		}
		
		SideNavigation.propTypes = {
		  classes: PropTypes.object.isRequired,
		  currentUser: PropTypes.object
		};
		
		SideNavigation.displayName = "SideNavigation";
		
		registerComponent(
		  "SideNavigation",
		  SideNavigation,
		  [withStyles, styles],
		  withCurrentUser
		);
	'''

	def genLoginJsx(Resource resource, IFileSystemAccess2 fsa) '''
		import React, { Component } from "react";
		import { Paper, Avatar, Typography } from "@material-ui/core";
		import { Lock } from "mdi-material-ui";
		import withStyles from "@material-ui/core/styles/withStyles";
		import {
		  registerComponent,
		  Components,
		  withCurrentUser
		} from "meteor/vulcan:core";
		
		const styles = theme => ({
		  layout: {
		    width: "auto",
		    display: "block", // Fix IE 11 issue.
		    marginLeft: theme.spacing.unit * 3,
		    marginRight: theme.spacing.unit * 3,
		    [theme.breakpoints.up(400 + theme.spacing.unit * 3 * 2)]: {
		      width: 400,
		      marginLeft: "auto",
		      marginRight: "auto"
		    }
		  },
		  paper: {
		    marginTop: theme.spacing.unit * 8,
		    display: "flex",
		    flexDirection: "column",
		    alignItems: "center",
		    padding: `${theme.spacing.unit * 2}px ${theme.spacing.unit * 3}px ${theme
		      .spacing.unit * 3}px`
		  },
		  avatar: {
		    margin: theme.spacing.unit,
		    backgroundColor: theme.palette.secondary.main
		  }
		});
		
		class Login extends Component {
		  render() {
		    const { classes } = this.props;
		    return (
		      <main className={classes.layout}>
		        <Paper className={classes.paper}>
		          <Avatar className={classes.avatar}>
		            <Lock />
		          </Avatar>
		          <Typography component="h1" variant="h5">
		            Login
		          </Typography>
		          <Components.AccountsLoginForm />
		        </Paper>
		      </main>
		    );
		  }
		}
		registerComponent({
		  name: "Login",
		  component: Login,
		  hocs: [withCurrentUser, [withStyles, styles]]
		});
	'''

	def int countPageLanmarks(ModuleRef m) {
		var count = 0
		
		for (page : m.module_ref.elements.filter(typeof(PageContainer))) {
			if (page.landmark!==null && page.landmark.trim.equals("true")) {
				count++
			}
		}
		
		return count
	}
}