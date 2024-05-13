import 'package:fhir_r4/fhir_r4.dart';

import '../firely.dart';

abstract class TypedElement extends BaseElementNavigator<TypedElement> {
  /// An indication of the location of this node within the data represented by the
  /// ITypedElement.
  ///
  /// The format of the location is the dotted name of the property, including indices
  /// to make sure repeated occurrences of an element can be distinguished. It needs
  /// to be sufficiently precise to aid the user in locating issues in the data.
  String get location;

  ElementDefinitionSummary get definition;
}


extension ElementDefinitionSummary on ElementDefinition{

  String get collection => this.;

    string ElementName { get; }


    bool IsRequired { get; }

    bool InSummary { get; }

    bool IsChoiceElement { get; }

    bool IsResource { get; }

    //
    // Summary:
    //     If this modifies the meaning of other elements
    bool IsModifier { get; }

    ITypeSerializationInfo[] Type { get; }

    //
    // Summary:
    //     Logical Models where a choice type is represented by ElementDefinition.representation
    //     = typeAttr might define a default type (elementdefinition-defaulttype extension).
    //     null in most cases.
    string DefaultTypeName { get; }

    //
    // Summary:
    //     This is the namespace used for the xml node representing this element. Only need
    //     to be set if different from "http://hl7.org/fhir".
    string NonDefaultNamespace { get; }

    //
    // Summary:
    //     The kind of node used to represent this element in XML. Default is Hl7.Fhir.Specification.XmlRepresentation.XmlElement.
    XmlRepresentation Representation { get; }

    int Order { get; }
}
#if false // Decompilation log
'200' items in cache
------------------
Resolve: 'System.Runtime, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
Found single assembly: 'System.Runtime, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
Load from: '/usr/lib/dotnet/packs/Microsoft.NETCore.App.Ref/8.0.3/ref/net8.0/System.Runtime.dll'
------------------
Resolve: 'System.Text.RegularExpressions, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
Found single assembly: 'System.Text.RegularExpressions, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
Load from: '/usr/lib/dotnet/packs/Microsoft.NETCore.App.Ref/8.0.3/ref/net8.0/System.Text.RegularExpressions.dll'
------------------
Resolve: 'System.Collections, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
Found single assembly: 'System.Collections, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
Load from: '/usr/lib/dotnet/packs/Microsoft.NETCore.App.Ref/8.0.3/ref/net8.0/System.Collections.dll'
------------------
Resolve: 'System.Collections.Concurrent, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
Found single assembly: 'System.Collections.Concurrent, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
Load from: '/usr/lib/dotnet/packs/Microsoft.NETCore.App.Ref/8.0.3/ref/net8.0/System.Collections.Concurrent.dll'
------------------
Resolve: 'System.ComponentModel.Annotations, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
Found single assembly: 'System.ComponentModel.Annotations, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
Load from: '/usr/lib/dotnet/packs/Microsoft.NETCore.App.Ref/8.0.3/ref/net8.0/System.ComponentModel.Annotations.dll'
------------------
Resolve: 'System.Xml.XDocument, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
Found single assembly: 'System.Xml.XDocument, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
Load from: '/usr/lib/dotnet/packs/Microsoft.NETCore.App.Ref/8.0.3/ref/net8.0/System.Xml.XDocument.dll'
------------------
Resolve: 'System.Xml.ReaderWriter, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
Found single assembly: 'System.Xml.ReaderWriter, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
Load from: '/usr/lib/dotnet/packs/Microsoft.NETCore.App.Ref/8.0.3/ref/net8.0/System.Xml.ReaderWriter.dll'
------------------
Resolve: 'System.IO.Compression, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'
Found single assembly: 'System.IO.Compression, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'
Load from: '/usr/lib/dotnet/packs/Microsoft.NETCore.App.Ref/8.0.3/ref/net8.0/System.IO.Compression.dll'
------------------
Resolve: 'System.Reflection.Emit.ILGeneration, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
Found single assembly: 'System.Reflection.Emit.ILGeneration, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
Load from: '/usr/lib/dotnet/packs/Microsoft.NETCore.App.Ref/8.0.3/ref/net8.0/System.Reflection.Emit.ILGeneration.dll'
------------------
Resolve: 'System.Reflection.Emit.Lightweight, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
Found single assembly: 'System.Reflection.Emit.Lightweight, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
Load from: '/usr/lib/dotnet/packs/Microsoft.NETCore.App.Ref/8.0.3/ref/net8.0/System.Reflection.Emit.Lightweight.dll'
------------------
Resolve: 'Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed'
Found single assembly: 'Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed'
Load from: '/home/grey/.nuget/packages/newtonsoft.json/13.0.3/lib/net6.0/Newtonsoft.Json.dll'
------------------
Resolve: 'System.Net.Primitives, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
Found single assembly: 'System.Net.Primitives, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
Load from: '/usr/lib/dotnet/packs/Microsoft.NETCore.App.Ref/8.0.3/ref/net8.0/System.Net.Primitives.dll'
------------------
Resolve: 'System.Net.Http, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
Found single assembly: 'System.Net.Http, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
Load from: '/usr/lib/dotnet/packs/Microsoft.NETCore.App.Ref/8.0.3/ref/net8.0/System.Net.Http.dll'
------------------
Resolve: 'System.Runtime.Serialization.Primitives, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
Found single assembly: 'System.Runtime.Serialization.Primitives, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
Load from: '/usr/lib/dotnet/packs/Microsoft.NETCore.App.Ref/8.0.3/ref/net8.0/System.Runtime.Serialization.Primitives.dll'
------------------
Resolve: 'System.ObjectModel, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
Found single assembly: 'System.ObjectModel, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
Load from: '/usr/lib/dotnet/packs/Microsoft.NETCore.App.Ref/8.0.3/ref/net8.0/System.ObjectModel.dll'
------------------
Resolve: 'System.Linq, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
Found single assembly: 'System.Linq, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
Load from: '/usr/lib/dotnet/packs/Microsoft.NETCore.App.Ref/8.0.3/ref/net8.0/System.Linq.dll'
------------------
Resolve: 'System.Text.Json, Version=8.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'
Found single assembly: 'System.Text.Json, Version=8.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'
Load from: '/usr/lib/dotnet/packs/Microsoft.NETCore.App.Ref/8.0.3/ref/net8.0/System.Text.Json.dll'
------------------
Resolve: 'System.Runtime.Numerics, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
Found single assembly: 'System.Runtime.Numerics, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
Load from: '/usr/lib/dotnet/packs/Microsoft.NETCore.App.Ref/8.0.3/ref/net8.0/System.Runtime.Numerics.dll'
------------------
Resolve: 'Fhir.Metrics, Version=1.2.2.0, Culture=neutral, PublicKeyToken=43e377ac229b6873'
Found single assembly: 'Fhir.Metrics, Version=1.2.2.0, Culture=neutral, PublicKeyToken=43e377ac229b6873'
Load from: '/home/grey/.nuget/packages/fhir.metrics/1.2.2/lib/netstandard2.0/Fhir.Metrics.dll'
------------------
Resolve: 'System.Memory, Version=8.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'
Found single assembly: 'System.Memory, Version=8.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'
Load from: '/usr/lib/dotnet/packs/Microsoft.NETCore.App.Ref/8.0.3/ref/net8.0/System.Memory.dll'
------------------
Resolve: 'System.Threading, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
Found single assembly: 'System.Threading, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
Load from: '/usr/lib/dotnet/packs/Microsoft.NETCore.App.Ref/8.0.3/ref/net8.0/System.Threading.dll'
------------------
Resolve: 'System.IO.Compression.ZipFile, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'
Found single assembly: 'System.IO.Compression.ZipFile, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'
Load from: '/usr/lib/dotnet/packs/Microsoft.NETCore.App.Ref/8.0.3/ref/net8.0/System.IO.Compression.ZipFile.dll'
------------------
Resolve: 'System.Reflection.Primitives, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
Found single assembly: 'System.Reflection.Primitives, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
Load from: '/usr/lib/dotnet/packs/Microsoft.NETCore.App.Ref/8.0.3/ref/net8.0/System.Reflection.Primitives.dll'
------------------
Resolve: 'System.Text.Encoding.Extensions, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
Found single assembly: 'System.Text.Encoding.Extensions, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
Load from: '/usr/lib/dotnet/packs/Microsoft.NETCore.App.Ref/8.0.3/ref/net8.0/System.Text.Encoding.Extensions.dll'
------------------
Resolve: 'System.Net.Mail, Version=8.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'
Found single assembly: 'System.Net.Mail, Version=8.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'
Load from: '/usr/lib/dotnet/packs/Microsoft.NETCore.App.Ref/8.0.3/ref/net8.0/System.Net.Mail.dll'
------------------
Resolve: 'System.Text.Encodings.Web, Version=8.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'
Found single assembly: 'System.Text.Encodings.Web, Version=8.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'
Load from: '/usr/lib/dotnet/packs/Microsoft.NETCore.App.Ref/8.0.3/ref/net8.0/System.Text.Encodings.Web.dll'
------------------
Resolve: 'System.Runtime.InteropServices, Version=8.0.0.0, Culture=neutral, PublicKeyToken=null'
Found single assembly: 'System.Runtime.InteropServices, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
Load from: '/usr/lib/dotnet/packs/Microsoft.NETCore.App.Ref/8.0.3/ref/net8.0/System.Runtime.InteropServices.dll'
------------------
Resolve: 'System.Runtime.CompilerServices.Unsafe, Version=8.0.0.0, Culture=neutral, PublicKeyToken=null'
Found single assembly: 'System.Runtime.CompilerServices.Unsafe, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
Load from: '/usr/lib/dotnet/packs/Microsoft.NETCore.App.Ref/8.0.3/ref/net8.0/System.Runtime.CompilerServices.Unsafe.dll'
#endif
